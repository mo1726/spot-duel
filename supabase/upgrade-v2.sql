-- Run ONCE after the original schema.sql on the EXISTING Supabase project.
-- Players solve the same six differences independently.
create table if not exists public.duel_player_finds (
  room_id uuid not null references public.duel_rooms(id) on delete cascade,
  player_id uuid not null references auth.users(id),
  diff_id integer not null references public.duel_answers(diff_id),
  created_at timestamptz not null default now(),
  primary key(room_id,player_id,diff_id)
);
alter table public.duel_player_finds enable row level security;
revoke all on public.duel_player_finds from anon,authenticated;
alter table public.duel_rooms add column if not exists host_finished_at timestamptz;
alter table public.duel_rooms add column if not exists guest_finished_at timestamptz;
-- New art: coordinates are percentages relative to each image.
truncate table public.duel_claims;
truncate table public.duel_player_finds;
delete from public.duel_answers;
insert into public.duel_answers(diff_id,x,y) values
 (1,0.169,0.182), -- small robot
 (2,0.697,0.110), -- star
 (3,0.323,0.697), -- crystals
 (4,0.715,0.686), -- apple
 (5,0.809,0.164), -- moon
 (6,0.875,0.444); -- cube

create or replace function public.duel_pick(p_code text,p_x double precision,p_y double precision)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; a record; v_count integer;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  if p_x is null or p_y is null or p_x<0 or p_x>1 or p_y<0 or p_y>1 then raise exception 'Invalid coordinates'; end if;
  select * into v from public.duel_rooms where code=upper(trim(p_code)) for update;
  if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then
    raise exception 'Not a room member'; end if;
  if v.started_at is null or now()<v.started_at or now()>=v.ends_at then
    return jsonb_build_object('result','not_active'); end if;
  if (auth.uid()=v.host_id and v.host_finished_at is not null) or
     (auth.uid()=v.guest_id and v.guest_finished_at is not null) then
    return jsonb_build_object('result','complete'); end if;
  select ans.diff_id into a from public.duel_answers ans
    where power(ans.x-p_x,2)+power(ans.y-p_y,2)<power(0.038,2)
    order by power(ans.x-p_x,2)+power(ans.y-p_y,2) limit 1;
  if not found then return jsonb_build_object('result','miss'); end if;
  if exists (select 1 from public.duel_player_finds
      where room_id=v.id and player_id=auth.uid() and diff_id=a.diff_id) then
    return jsonb_build_object('result','claimed'); end if;
  insert into public.duel_player_finds(room_id,player_id,diff_id)
    values (v.id,auth.uid(),a.diff_id);
  select count(*) into v_count from public.duel_player_finds
    where room_id=v.id and player_id=auth.uid();
  update public.duel_rooms set
    host_score=case when host_id=auth.uid() then v_count else host_score end,
    guest_score=case when guest_id=auth.uid() then v_count else guest_score end,
    host_finished_at=case when host_id=auth.uid() and v_count=6 then now() else host_finished_at end,
    guest_finished_at=case when guest_id=auth.uid() and v_count=6 then now() else guest_finished_at end
  where id=v.id;
  return jsonb_build_object('result','hit','diff_id',a.diff_id,'found',v_count);
end $$;

create or replace function public.duel_state(p_code text)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; v_claims jsonb;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  select * into v from public.duel_rooms where code=upper(trim(p_code));
  if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then
    raise exception 'Room not found or access denied'; end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'diff_id',c.diff_id,'x',a.x,'y',a.y
  ) order by c.diff_id),'[]'::jsonb) into v_claims
  from public.duel_player_finds c join public.duel_answers a on a.diff_id=c.diff_id
  where c.room_id=v.id and c.player_id=auth.uid();
  return jsonb_build_object(
    'code',v.code,'is_host',v.host_id=auth.uid(),
    'host_name',v.host_name,'guest_name',v.guest_name,
    'host_ready',v.host_ready,'guest_ready',v.guest_ready,
    'host_score',v.host_score,'guest_score',v.guest_score,
    'host_finished_at',v.host_finished_at,'guest_finished_at',v.guest_finished_at,
    'started_at',v.started_at,'ends_at',v.ends_at,
    'claims',v_claims);
end $$;

-- 120-second challenge for new rooms. Running matches created under v1 keep their old end time.
create or replace function public.duel_ready(p_code text)
returns void language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; h boolean; g boolean;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  select * into v from public.duel_rooms where code=upper(trim(p_code)) for update;
  if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then
    raise exception 'Not a room member'; end if;
  if v.guest_id is null then raise exception 'Wait for your opponent'; end if;
  if v.started_at is not null then return; end if;
  h := v.host_ready or v.host_id=auth.uid();
  g := v.guest_ready or v.guest_id=auth.uid();
  update public.duel_rooms set host_ready=h,guest_ready=g,
    started_at=case when h and g then now() + interval '3 seconds' else null end,
    ends_at=case when h and g then now() + interval '123 seconds' else null end
  where id=v.id;
end $$;
