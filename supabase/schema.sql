-- Run ONCE in Supabase SQL Editor on a fresh project.
-- The private answer coordinates are never directly selectable by browser clients.
create extension if not exists pgcrypto;

create table if not exists public.duel_rooms (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  host_id uuid not null references auth.users(id),
  guest_id uuid references auth.users(id),
  host_name text not null,
  guest_name text,
  host_ready boolean not null default false,
  guest_ready boolean not null default false,
  host_score integer not null default 0,
  guest_score integer not null default 0,
  started_at timestamptz,
  ends_at timestamptz,
  created_at timestamptz not null default now(),
  constraint no_self_join check (guest_id is null or guest_id <> host_id)
);
create table if not exists public.duel_answers (
  diff_id integer primary key,
  x double precision not null,
  y double precision not null
);
insert into public.duel_answers(diff_id,x,y) values
  (1, 0.202, 0.228), -- sun
  (2, 0.373, 0.235), -- cloud
  (3, 0.403, 0.525), -- clock
  (4, 0.817, 0.485), -- flower
  (5, 0.480, 0.908)  -- rug
on conflict (diff_id) do update set x=excluded.x,y=excluded.y;
create table if not exists public.duel_claims (
  room_id uuid not null references public.duel_rooms(id) on delete cascade,
  diff_id integer not null references public.duel_answers(diff_id),
  player_id uuid not null references auth.users(id),
  created_at timestamptz not null default now(),
  primary key(room_id,diff_id)
);

alter table public.duel_rooms enable row level security;
alter table public.duel_claims enable row level security;
alter table public.duel_answers enable row level security;
-- Realtime checks this SELECT RLS policy when broadcasting Postgres Changes.
create policy "members read their rooms" on public.duel_rooms
for select to authenticated using (auth.uid()=host_id or auth.uid()=guest_id);
-- No insert/update/delete policies: game mutations happen through the RPC functions below.
revoke all on public.duel_answers from anon, authenticated;
revoke all on public.duel_claims from anon, authenticated;
grant select on public.duel_rooms to authenticated;

create or replace function public.duel_create(p_name text)
returns text language plpgsql security definer set search_path = '' as $$
declare v_code text; v_try int := 0;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  if length(trim(coalesce(p_name,''))) not between 1 and 20 then raise exception 'Name must have 1-20 characters'; end if;
  loop
    v_code := upper(substr(md5(gen_random_uuid()::text),1,6));
    begin
      insert into public.duel_rooms(code,host_id,host_name) values(v_code,auth.uid(),trim(p_name));
      return v_code;
    exception when unique_violation then
      v_try := v_try + 1;
      if v_try > 8 then raise exception 'Could not generate room code'; end if;
    end;
  end loop;
end $$;

create or replace function public.duel_join(p_code text,p_name text)
returns text language plpgsql security definer set search_path = '' as $$
declare v_room public.duel_rooms%rowtype;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  if length(trim(coalesce(p_name,''))) not between 1 and 20 then raise exception 'Name must have 1-20 characters'; end if;
  select * into v_room from public.duel_rooms where code=upper(trim(p_code)) for update;
  if not found then raise exception 'Room not found'; end if;
  if v_room.host_id=auth.uid() or v_room.guest_id=auth.uid() then return v_room.code; end if;
  if v_room.guest_id is not null then raise exception 'Room is already full'; end if;
  if v_room.started_at is not null then raise exception 'Game already started'; end if;
  update public.duel_rooms set guest_id=auth.uid(),guest_name=trim(p_name),guest_ready=false
    where id=v_room.id;
  return v_room.code;
end $$;

create or replace function public.duel_ready(p_code text)
returns void language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; h boolean; g boolean;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  select * into v from public.duel_rooms where code=upper(trim(p_code)) for update;
  if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then
    raise exception 'Not a room member';
  end if;
  if v.guest_id is null then raise exception 'Wait for your opponent'; end if;
  if v.started_at is not null then return; end if;
  h := v.host_ready or v.host_id=auth.uid();
  g := v.guest_ready or v.guest_id=auth.uid();
  update public.duel_rooms set host_ready=h,guest_ready=g,
    started_at=case when h and g then now() + interval '3 seconds' else null end,
    ends_at=case when h and g then now() + interval '93 seconds' else null end
  where id=v.id;
end $$;

create or replace function public.duel_pick(p_code text,p_x double precision,p_y double precision)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; a record;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  if p_x is null or p_y is null or p_x<0 or p_x>1 or p_y<0 or p_y>1 then raise exception 'Invalid coordinates'; end if;
  select * into v from public.duel_rooms where code=upper(trim(p_code)) for update;
  if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then
    raise exception 'Not a room member';
  end if;
  if v.started_at is null or now()<v.started_at or now()>=v.ends_at then
    return jsonb_build_object('result','not_active');
  end if;
  select ans.diff_id into a from public.duel_answers ans
    where power(ans.x-p_x,2)+power(ans.y-p_y,2)<power(0.048,2)
    order by power(ans.x-p_x,2)+power(ans.y-p_y,2) limit 1;
  if not found then return jsonb_build_object('result','miss'); end if;
  if exists (select 1 from public.duel_claims where room_id=v.id and diff_id=a.diff_id) then
    return jsonb_build_object('result','claimed');
  end if;
  insert into public.duel_claims(room_id,diff_id,player_id) values(v.id,a.diff_id,auth.uid());
  update public.duel_rooms set
    host_score=host_score+case when auth.uid()=host_id then 20 else 0 end,
    guest_score=guest_score+case when auth.uid()=guest_id then 20 else 0 end
  where id=v.id;
  return jsonb_build_object('result','hit','diff_id',a.diff_id);
end $$;

create or replace function public.duel_state(p_code text)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; v_claims jsonb;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  select * into v from public.duel_rooms where code=upper(trim(p_code));
  if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then
    raise exception 'Room not found or access denied';
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'diff_id',c.diff_id,'x',a.x,'y',a.y,'is_mine',c.player_id=auth.uid()
  ) order by c.diff_id),'[]'::jsonb) into v_claims
  from public.duel_claims c join public.duel_answers a on a.diff_id=c.diff_id where c.room_id=v.id;
  return jsonb_build_object(
    'code',v.code,'is_host',v.host_id=auth.uid(),
    'host_name',v.host_name,'guest_name',v.guest_name,
    'host_ready',v.host_ready,'guest_ready',v.guest_ready,
    'host_score',v.host_score,'guest_score',v.guest_score,
    'started_at',v.started_at,'ends_at',v.ends_at,
    'claims',v_claims
  );
end $$;

revoke all on function public.duel_create(text) from public,anon;
revoke all on function public.duel_join(text,text) from public,anon;
revoke all on function public.duel_ready(text) from public,anon;
revoke all on function public.duel_pick(text,double precision,double precision) from public,anon;
revoke all on function public.duel_state(text) from public,anon;
grant execute on function public.duel_create(text) to authenticated;
grant execute on function public.duel_join(text,text) to authenticated;
grant execute on function public.duel_ready(text) to authenticated;
grant execute on function public.duel_pick(text,double precision,double precision) to authenticated;
grant execute on function public.duel_state(text) to authenticated;

-- Replicate only member-visible room updates; use polling as a fallback in the client.
do $$ begin
  alter publication supabase_realtime add table public.duel_rooms;
exception when duplicate_object then null;
end $$;
