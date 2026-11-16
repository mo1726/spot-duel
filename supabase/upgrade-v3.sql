-- Spot Duel V3 — run AFTER schema.sql and upgrade-v2.sql.
-- Existing rooms should not be used after this migration; create new rooms.
create table if not exists public.duel_odd_answers (
  round_no integer primary key check(round_no between 1 and 10),
  answer integer not null check(answer between 1 and 4)
);
insert into public.duel_odd_answers(round_no,answer) values
 (1,2),(2,3),(3,1),(4,4),(5,2),(6,1),(7,3),(8,4),(9,1),(10,2)
on conflict(round_no) do update set answer=excluded.answer;
alter table public.duel_odd_answers enable row level security;
revoke all on public.duel_odd_answers from anon,authenticated;

create table if not exists public.duel_odd_attempts (
 room_id uuid not null references public.duel_rooms(id) on delete cascade,
 player_id uuid not null references auth.users(id),
 round_no int not null references public.duel_odd_answers(round_no),
 chosen int not null check(chosen between 1 and 4),
 correct boolean not null,
 created_at timestamptz not null default now(),
 primary key(room_id,player_id,round_no)
);
alter table public.duel_odd_attempts enable row level security;
revoke all on public.duel_odd_attempts from anon,authenticated;

create or replace function public.duel_choose(p_code text,p_round integer,p_choice integer)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; v_expected int; v_answer int; v_correct boolean; v_count int; v_score int;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 if p_round not between 1 and 10 or p_choice not between 1 and 4 then raise exception 'Invalid choice'; end if;
 select * into v from public.duel_rooms where code=upper(trim(p_code)) for update;
 if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then
   raise exception 'Not a room member';
 end if;
 if v.started_at is null or now()<v.started_at or now()>=v.ends_at then
   return jsonb_build_object('result','not_active','correct',false);
 end if;
 if (auth.uid()=v.host_id and v.host_finished_at is not null) or
    (auth.uid()=v.guest_id and v.guest_finished_at is not null) then
   return jsonb_build_object('result','complete','correct',false);
 end if;
 select count(*)+1 into v_expected from public.duel_odd_attempts
 where room_id=v.id and player_id=auth.uid();
 if p_round<>v_expected then raise exception 'Round out of order or already answered'; end if;
 select answer into v_answer from public.duel_odd_answers where round_no=p_round;
 v_correct := (p_choice=v_answer);
 insert into public.duel_odd_attempts(room_id,player_id,round_no,chosen,correct)
 values(v.id,auth.uid(),p_round,p_choice,v_correct);
 select count(*),count(*) filter(where correct) into v_count,v_score
 from public.duel_odd_attempts where room_id=v.id and player_id=auth.uid();
 update public.duel_rooms set
   host_score=case when host_id=auth.uid() then v_score else host_score end,
   guest_score=case when guest_id=auth.uid() then v_score else guest_score end,
   host_finished_at=case when host_id=auth.uid() and v_count=10 then now() else host_finished_at end,
   guest_finished_at=case when guest_id=auth.uid() and v_count=10 then now() else guest_finished_at end
 where id=v.id;
 return jsonb_build_object('result','answered','correct',v_correct,'answered',v_count,'score',v_score);
end $$;

create or replace function public.duel_state(p_code text)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; v_round integer;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 select * into v from public.duel_rooms where code=upper(trim(p_code));
 if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then
   raise exception 'Room not found or access denied'; end if;
 select count(*) into v_round from public.duel_odd_attempts where room_id=v.id and player_id=auth.uid();
 return jsonb_build_object(
   'code',v.code,'is_host',v.host_id=auth.uid(),
   'host_name',v.host_name,'guest_name',v.guest_name,
   'host_ready',v.host_ready,'guest_ready',v.guest_ready,
   'host_score',v.host_score,'guest_score',v.guest_score,
   'host_finished_at',v.host_finished_at,'guest_finished_at',v.guest_finished_at,
   'started_at',v.started_at,'ends_at',v.ends_at,'my_round',v_round);
end $$;

-- Match lasts 120 sec after countdown.
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
 h:=v.host_ready or v.host_id=auth.uid(); g:=v.guest_ready or v.guest_id=auth.uid();
 update public.duel_rooms set host_ready=h,guest_ready=g,
 started_at=case when h and g then now()+interval '3 seconds' else null end,
 ends_at=case when h and g then now()+interval '123 seconds' else null end
 where id=v.id;
end $$;

revoke all on function public.duel_choose(text,integer,integer) from public,anon;
grant execute on function public.duel_choose(text,integer,integer) to authenticated;
