-- Spot Duel V5 — runs AFTER V4 migration. End active matches before running.
-- All choices in a puzzle come from ONE product family. Exactly one has the stated visual feature.
-- All question copy and answer explanations are Darija, in Arabic script.
-- Rebuilds puzzle bank; existing active matches must be abandoned.
DELETE FROM public.duel_v4_puzzles;
INSERT INTO public.duel_v4_puzzles(id,category,question,question_ar,explanation,options,correct_choice) VALUES
(1,'water','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة ديال الماء كبيرة وعندها مقبض، والباقي قراعي صغار.','["water-5", "water-4", "water-3", "water-1"]'::jsonb,2),
(2,'shampoo','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة عندها غطا عادي، والباقي بقنينة فيها بومبة.','["shampoo-2", "shampoo-5", "shampoo-3", "shampoo-1"]'::jsonb,1),
(3,'chocolate','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة شوكولا بيضا، والباقي لونهم بني.','["chocolate-6", "chocolate-1", "chocolate-4", "chocolate-2"]'::jsonb,4),
(4,'juice','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فعْبوة على شكل قرعة، والباقي فعُلب كارتون.','["juice-2", "juice-1", "juice-3", "juice-6"]'::jsonb,4),
(5,'cream','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة القارورة ديالها شفافة وغطاها ذهبي، والباقي علب ملوّنة.','["cream-4", "cream-3", "cream-2", "cream-5"]'::jsonb,1),
(6,'soda','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فقرعة ديال البلاستيك، والباقي فكانيتات.','["soda-3", "soda-1", "soda-2", "soda-6"]'::jsonb,4),
(7,'water','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة ديال الماء كبيرة وعندها مقبض، والباقي قراعي صغار.','["water-4", "water-2", "water-1", "water-6"]'::jsonb,1),
(8,'water','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة ديال الماء كبيرة وعندها مقبض، والباقي قراعي صغار.','["water-6", "water-1", "water-3", "water-4"]'::jsonb,4),
(9,'chocolate','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة شوكولا بيضا، والباقي لونهم بني.','["chocolate-4", "chocolate-3", "chocolate-2", "chocolate-1"]'::jsonb,3),
(10,'water','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة ديال الماء كبيرة وعندها مقبض، والباقي قراعي صغار.','["water-4", "water-6", "water-1", "water-5"]'::jsonb,1),
(11,'water','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','3 قراعي ديال البلاستيك ووحدة ديال الزاج.','["water-1", "water-5", "water-6", "water-2"]'::jsonb,2),
(12,'water','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','3 قراعي ديال البلاستيك ووحدة ديال الزاج.','["water-6", "water-3", "water-2", "water-1"]'::jsonb,2),
(13,'cream','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة القارورة ديالها شفافة وغطاها ذهبي، والباقي علب ملوّنة.','["cream-1", "cream-6", "cream-4", "cream-2"]'::jsonb,3),
(14,'cream','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة القارورة ديالها شفافة وغطاها ذهبي، والباقي علب ملوّنة.','["cream-3", "cream-6", "cream-4", "cream-1"]'::jsonb,3),
(15,'juice','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة لون العصير فيها حمر، والباقي برتقالي.','["juice-4", "juice-1", "juice-5", "juice-6"]'::jsonb,4),
(16,'chocolate','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة شوكولا بيضا، والباقي لونهم بني.','["chocolate-3", "chocolate-1", "chocolate-6", "chocolate-2"]'::jsonb,4),
(17,'juice','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فعْبوة على شكل قرعة، والباقي فعُلب كارتون.','["juice-1", "juice-2", "juice-3", "juice-5"]'::jsonb,4),
(18,'cream','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة القارورة ديالها شفافة وغطاها ذهبي، والباقي علب ملوّنة.','["cream-1", "cream-2", "cream-3", "cream-4"]'::jsonb,4),
(19,'soda','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فقرعة ديال البلاستيك، والباقي فكانيتات.','["soda-3", "soda-1", "soda-5", "soda-2"]'::jsonb,3),
(20,'water','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة ديال الماء كبيرة وعندها مقبض، والباقي قراعي صغار.','["water-5", "water-2", "water-1", "water-4"]'::jsonb,4),
(21,'cream','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة القارورة ديالها شفافة وغطاها ذهبي، والباقي علب ملوّنة.','["cream-2", "cream-1", "cream-5", "cream-4"]'::jsonb,4),
(22,'chocolate','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة شوكولا بيضا، والباقي لونهم بني.','["chocolate-6", "chocolate-3", "chocolate-2", "chocolate-5"]'::jsonb,3),
(23,'chocolate','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة شوكولا بيضا، والباقي لونهم بني.','["chocolate-4", "chocolate-2", "chocolate-5", "chocolate-1"]'::jsonb,2),
(24,'juice','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فعْبوة على شكل قرعة، والباقي فعُلب كارتون.','["juice-4", "juice-1", "juice-3", "juice-2"]'::jsonb,1),
(25,'soda','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فقرعة ديال البلاستيك، والباقي فكانيتات.','["soda-4", "soda-5", "soda-2", "soda-3"]'::jsonb,2),
(26,'shampoo','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة عندها غطا عادي، والباقي بقنينة فيها بومبة.','["shampoo-1", "shampoo-3", "shampoo-5", "shampoo-6"]'::jsonb,4),
(27,'water','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة ديال الماء كبيرة وعندها مقبض، والباقي قراعي صغار.','["water-4", "water-6", "water-2", "water-5"]'::jsonb,1),
(28,'juice','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة لون العصير فيها حمر، والباقي برتقالي.','["juice-4", "juice-5", "juice-6", "juice-3"]'::jsonb,3),
(29,'soda','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فقرعة ديال البلاستيك، والباقي فكانيتات.','["soda-4", "soda-1", "soda-2", "soda-5"]'::jsonb,4),
(30,'chocolate','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة شوكولا بيضا، والباقي لونهم بني.','["chocolate-6", "chocolate-3", "chocolate-2", "chocolate-4"]'::jsonb,3),
(31,'shampoo','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فيها بومبة باش تضغط عليها، والباقي عندهم غطا.','["shampoo-4", "shampoo-1", "shampoo-6", "shampoo-2"]'::jsonb,2),
(32,'chocolate','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة شوكولا بيضا، والباقي لونهم بني.','["chocolate-1", "chocolate-2", "chocolate-5", "chocolate-3"]'::jsonb,2),
(33,'shampoo','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فيها بومبة باش تضغط عليها، والباقي عندهم غطا.','["shampoo-3", "shampoo-6", "shampoo-2", "shampoo-4"]'::jsonb,1),
(34,'chocolate','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة شوكولا بيضا، والباقي لونهم بني.','["chocolate-5", "chocolate-2", "chocolate-3", "chocolate-4"]'::jsonb,2),
(35,'cream','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة القارورة ديالها شفافة وغطاها ذهبي، والباقي علب ملوّنة.','["cream-2", "cream-5", "cream-6", "cream-4"]'::jsonb,4),
(36,'soda','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فقرعة ديال البلاستيك، والباقي فكانيتات.','["soda-4", "soda-1", "soda-2", "soda-6"]'::jsonb,4),
(37,'cream','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة القارورة ديالها شفافة وغطاها ذهبي، والباقي علب ملوّنة.','["cream-3", "cream-6", "cream-5", "cream-4"]'::jsonb,4),
(38,'soda','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فقرعة ديال البلاستيك، والباقي فكانيتات.','["soda-1", "soda-3", "soda-6", "soda-4"]'::jsonb,3),
(39,'water','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة ديال الماء كبيرة وعندها مقبض، والباقي قراعي صغار.','["water-1", "water-4", "water-2", "water-3"]'::jsonb,2),
(40,'cream','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة القارورة ديالها شفافة وغطاها ذهبي، والباقي علب ملوّنة.','["cream-1", "cream-4", "cream-3", "cream-5"]'::jsonb,2),
(41,'chocolate','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة شوكولا بيضا، والباقي لونهم بني.','["chocolate-4", "chocolate-5", "chocolate-2", "chocolate-6"]'::jsonb,3),
(42,'cream','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة القارورة ديالها شفافة وغطاها ذهبي، والباقي علب ملوّنة.','["cream-4", "cream-6", "cream-3", "cream-2"]'::jsonb,1),
(43,'shampoo','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فيها بومبة باش تضغط عليها، والباقي عندهم غطا.','["shampoo-6", "shampoo-2", "shampoo-4", "shampoo-5"]'::jsonb,4),
(44,'cream','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة القارورة ديالها شفافة وغطاها ذهبي، والباقي علب ملوّنة.','["cream-1", "cream-6", "cream-5", "cream-4"]'::jsonb,4),
(45,'water','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة ديال الماء كبيرة وعندها مقبض، والباقي قراعي صغار.','["water-4", "water-5", "water-3", "water-6"]'::jsonb,1),
(46,'soda','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فقرعة ديال البلاستيك، والباقي فكانيتات.','["soda-4", "soda-3", "soda-6", "soda-2"]'::jsonb,3),
(47,'water','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة ديال الماء كبيرة وعندها مقبض، والباقي قراعي صغار.','["water-2", "water-4", "water-3", "water-5"]'::jsonb,2),
(48,'juice','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة لون العصير فيها حمر، والباقي برتقالي.','["juice-3", "juice-1", "juice-4", "juice-6"]'::jsonb,4),
(49,'juice','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة لون العصير فيها حمر، والباقي برتقالي.','["juice-3", "juice-6", "juice-5", "juice-1"]'::jsonb,2),
(50,'shampoo','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة عندها غطا عادي، والباقي بقنينة فيها بومبة.','["shampoo-1", "shampoo-3", "shampoo-5", "shampoo-4"]'::jsonb,4),
(51,'chocolate','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة شوكولا بيضا، والباقي لونهم بني.','["chocolate-2", "chocolate-6", "chocolate-1", "chocolate-5"]'::jsonb,1),
(52,'soda','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة فقرعة ديال البلاستيك، والباقي فكانيتات.','["soda-4", "soda-5", "soda-3", "soda-1"]'::jsonb,2),
(53,'water','فين كاينة المختلفة؟','ركز مزيان فالتفاصيل واختار الصورة اللي مختلفة على الباقي.','وحدة ديال الماء كبيرة وعندها مقبض، والباقي قراعي صغار.','["water-4", "water-2", "water-6", "water-3"]'::jsonb,1);

create or replace function public.duel_state(p_code text)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; v_round integer; q public.duel_v4_puzzles%rowtype; v_id integer;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 select * into v from public.duel_rooms where code=upper(trim(p_code));
 if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then raise exception 'Room not found or access denied'; end if;
 select count(*) into v_round from public.duel_odd_attempts where room_id=v.id and player_id=auth.uid();
 v_id := (((abs(hashtext(v.code)::bigint) % 53)::integer + v_round*37) % 53)+1;
 if v_round < 20 then select * into q from public.duel_v4_puzzles where id=v_id; end if;
 return jsonb_build_object(
   'code',v.code,'is_host',v.host_id=auth.uid(),
   'host_name',v.host_name,'guest_name',v.guest_name,
   'host_ready',v.host_ready,'guest_ready',v.guest_ready,
   'host_score',v.host_score,'guest_score',v.guest_score,
   'host_finished_at',v.host_finished_at,'guest_finished_at',v.guest_finished_at,
   'started_at',v.started_at,'ends_at',v.ends_at,'my_round',v_round,
   'question',case when v_round<20 then q.question else null end,
   'question_ar',case when v_round<20 then q.question_ar else null end,
   'options',case when v_round<20 then q.options else null end,
   'category',case when v_round<20 then q.category else null end
 );
end $$;

create or replace function public.duel_choose(p_code text,p_round integer,p_choice integer)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; v_expected int; q public.duel_v4_puzzles%rowtype; v_correct boolean; v_count int; v_score int; v_id int;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 if p_round not between 1 and 20 or p_choice not between 1 and 4 then raise exception 'Invalid choice'; end if;
 select * into v from public.duel_rooms where code=upper(trim(p_code)) for update;
 if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then raise exception 'Not a room member'; end if;
 if v.started_at is null or now()<v.started_at or now()>=v.ends_at then return jsonb_build_object('result','not_active'); end if;
 if (auth.uid()=v.host_id and v.host_finished_at is not null) or
    (auth.uid()=v.guest_id and v.guest_finished_at is not null) then
    return jsonb_build_object('result','complete');
 end if;
 select count(*)+1 into v_expected from public.duel_odd_attempts where room_id=v.id and player_id=auth.uid();
 if p_round<>v_expected then raise exception 'Round out of order or already answered'; end if;
 v_id := (((abs(hashtext(v.code)::bigint) % 53)::integer + (p_round-1)*37) % 53)+1;
 select * into q from public.duel_v4_puzzles where id=v_id;
 if not found then raise exception 'Question bank not installed'; end if;
 v_correct := p_choice=q.correct_choice;
 insert into public.duel_odd_attempts(room_id,player_id,round_no,chosen,correct)
 values(v.id,auth.uid(),p_round,p_choice,v_correct);
 select count(*),count(*) filter(where correct) into v_count,v_score
 from public.duel_odd_attempts where room_id=v.id and player_id=auth.uid();
 update public.duel_rooms set
 host_score=case when host_id=auth.uid() then v_score else host_score end,
 guest_score=case when guest_id=auth.uid() then v_score else guest_score end,
 host_finished_at=case when host_id=auth.uid() and v_count=20 then now() else host_finished_at end,
 guest_finished_at=case when guest_id=auth.uid() and v_count=20 then now() else guest_finished_at end
 where id=v.id;
 return jsonb_build_object('result','answered','correct',v_correct,'answered',v_count,'score',v_score,
 'correct_choice',q.correct_choice,'explanation',q.explanation);
end $$;

create or replace function public.duel_ready(p_code text)
returns void language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; h boolean; g boolean;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 select * into v from public.duel_rooms where code=upper(trim(p_code)) for update;
 if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then raise exception 'Not a room member'; end if;
 if v.guest_id is null then raise exception 'Wait for your opponent'; end if;
 if v.started_at is not null then return; end if;
 h:=v.host_ready or v.host_id=auth.uid(); g:=v.guest_ready or v.guest_id=auth.uid();
 update public.duel_rooms set host_ready=h,guest_ready=g,
 started_at=case when h and g then now()+interval '3 seconds' else null end,
 ends_at=case when h and g then now()+interval '303 seconds' else null end
 where id=v.id;
end $$;
revoke all on function public.duel_state(text) from public,anon;
revoke all on function public.duel_choose(text,integer,integer) from public,anon;
grant execute on function public.duel_state(text) to authenticated;
grant execute on function public.duel_choose(text,integer,integer) to authenticated;
