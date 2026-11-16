import React, { useCallback, useEffect, useRef, useState } from 'react'
import { ArrowRight, Check, Copy, Gamepad2, LoaderCircle, Play, ShieldCheck, Swords, Users, Trophy, Timer, RotateCcw, Sparkles, LockKeyhole } from 'lucide-react'
import { configured, supabase } from './supabase'

const TOTAL=20
const fromUrl=()=>new URLSearchParams(window.location.search).get('room')?.toUpperCase() || ''
const stamp=v=>v?new Date(v).getTime():null
const imageFor=id=>`/products/${id}.webp`
const secondsText=s=>`${String(Math.floor(s/60)).padStart(2,'0')}:${String(s%60).padStart(2,'0')}`
const preview=['shampoo-1','shampoo-3','shampoo-5','shampoo-4']

export default function App(){
 const [name,setName]=useState(localStorage.getItem('spot-name')||'')
 const [joinCode,setJoinCode]=useState(fromUrl())
 const [code,setCode]=useState('')
 const [state,setState]=useState(null)
 const [now,setNow]=useState(Date.now())
 const [error,setError]=useState('')
 const [loading,setLoading]=useState(false)
 const [authenticated,setAuthenticated]=useState(false)
 const [reveal,setReveal]=useState(null)
 const [copied,setCopied]=useState(false)
 const busy=useRef(false), current=useRef(''), revealLock=useRef(false)
 useEffect(()=>{
  if(!configured)return
  let alive=true
  async function signIn(){
   const {data,error:e}=await supabase.auth.getSession()
   if(e){if(alive)setError(e.message);return}
   if(data?.session){if(alive)setAuthenticated(true);return}
   const {error:e2}=await supabase.auth.signInAnonymously()
   if(alive){if(e2)setError(e2.message);else setAuthenticated(true)}
  }
  signIn();return()=>{alive=false}
 },[])
 const refresh=useCallback(async c=>{
  if(!c||!supabase||revealLock.current)return
  const {data,error:e}=await supabase.rpc('duel_state',{p_code:c})
  if(!e&&current.current===c)setState(data)
 },[])
 useEffect(()=>{
  current.current=code
  if(!code||!supabase)return
  refresh(code)
  const channel=supabase.channel('v4-'+code).on('postgres_changes',{
   event:'UPDATE',schema:'public',table:'duel_rooms'
  },p=>{if(p.new.code===code)refresh(code)}).subscribe()
  const poll=setInterval(()=>refresh(code),2000)
  return()=>{clearInterval(poll);supabase.removeChannel(channel)}
 },[code,refresh])
 useEffect(()=>{const tick=setInterval(()=>setNow(Date.now()),250);return()=>clearInterval(tick)},[])
 async function enter(kind){
  setError('')
  if(!authenticated){setError('الاتصال مازال ما واجدش. فعّل الدخول بلا حساب فـ Supabase.');return}
  if(name.trim().length<1||name.trim().length>20){setError('دخل سميتك، من حرف حتى لـ 20 حرف.');return}
  if(kind==='join'&&!/^[A-F0-9]{6}$/.test(joinCode.trim().toUpperCase())){setError('دخل كود الغرفة ديال 6 حروف.');return}
  setLoading(true)
  try{
   localStorage.setItem('spot-name',name.trim())
   const {data,error:e}=await supabase.rpc(kind==='create'?'duel_create':'duel_join',kind==='create'?{p_name:name.trim()}:{p_code:joinCode.trim().toUpperCase(),p_name:name.trim()})
   if(e)throw e
   current.current=data;setCode(data);setState(null);setReveal(null)
   window.history.replaceState(null,'','?room='+encodeURIComponent(data))
  }catch(e){setError(e.message||'ما قدرناش ندخلو للغرفة')}finally{setLoading(false)}
 }
 async function ready(){
  setError('');setLoading(true)
  const {error:e}=await supabase.rpc('duel_ready',{p_code:code})
  if(e)setError(e.message);else await refresh(code)
  setLoading(false)
 }
 async function pick(n){
  if(busy.current||revealLock.current||!state||state.my_round>=TOTAL)return
  busy.current=true;revealLock.current=true
  try{
   const {data,error:e}=await supabase.rpc('duel_choose',{p_code:code,p_round:state.my_round+1,p_choice:n})
   if(e)throw e
   if(data?.result!=='answered'){revealLock.current=false;setError('هاد الجولة مازال ما بداتش.');await refresh(code);return}
   setReveal({correct:data.correct,answer:data.correct_choice,choice:n,explanation:data.explanation,round:state.my_round+1})
  }catch(e){revealLock.current=false;setError(e.message||'ما قدرناش نسجلو الجواب');await refresh(code)}finally{busy.current=false}
 }
 async function nextQuestion(){setReveal(null);revealLock.current=false;await refresh(code)}
 function leave(){revealLock.current=false;setReveal(null);setCode('');setState(null);current.current='';setError('');window.history.replaceState(null,'',window.location.pathname)}
 async function copyInvite(){try{await navigator.clipboard.writeText(location.origin+'/?room='+code);setCopied(true);setTimeout(()=>setCopied(false),1200)}catch{setError('ما قدرناش ننسخو الرابط. صيفط كود الغرفة.')}}
 const start=stamp(state?.started_at),end=stamp(state?.ends_at)
 const waiting=!!(state&&!start),countdown=!!(start&&now<start)
 const finished=!!(start&&(now>=end||(state?.host_finished_at&&state?.guest_finished_at)))
 const playing=!!(start&&now>=start&&now<end&&!finished&&(state?.my_round??TOTAL)<TOTAL)
 const timeLeft=Math.max(0,Math.ceil((((countdown?start:end)||now)-now)/1000))
 const mine=state?.is_host?'host':'guest',myReady=state?.[mine+'_ready']
 const myScore=state?.[mine+'_score']??0,other=mine==='host'?'guest':'host',rivalScore=state?.[other+'_score']??0
 const winner=myScore===rivalScore?'draw':myScore>rivalScore?'win':'lose'
 const choices=Array.isArray(state?.options)?state.options:[]
 return <div className="app">
  <header className="topbar wrap"><div className="logo"><div className="logo-icon">⚡</div><strong>SPOT<span>DUEL</span></strong><small>فين كاينة المختلفة؟</small></div><div className="live"><i/> مباراة مباشرة <span>· جوج لاعبين</span></div></header>
  {!code?<main className="wrap home">
   <section className="hero"><div className="eyebrow"><Sparkles size={15}/> تحدي التركيز والملاحظة</div><h1>فين كاينة <em>المختلفة؟</em></h1><h2>4 صور، غير وحدة مختلفة!</h2><p>تحدى صاحبك فـ 20 جولة بالصور. قلب على المختلفة ودير جوابك بوحدك. <strong>فكر مزيان قبل ما تختار.</strong></p><div className="chips"><span>🎯 ألغاز متنوعة</span><span>📸 36 صورة ديال المنتجات</span><span>🕹️ تحدي خاص بين جوج</span></div></section>
   <section className="home-layout"><div className="panel start-panel"><div className="section-label"><Gamepad2 size={21}/> بدا التحدي</div><label>سميتك</label><input value={name} maxLength={20} onChange={e=>setName(e.target.value)} placeholder="مثلا: محسن"/><button className="gold-button" disabled={loading||!authenticated} onClick={()=>enter('create')}>{loading?<LoaderCircle className="spin" size={18}/>:<Play size={18}/>} صايب غرفة خاصة <ArrowRight size={18}/></button><div className="separation">ولا دخل عند صاحبك</div><label>كود الغرفة</label><div className="join"><input maxLength={6} value={joinCode} onChange={e=>setJoinCode(e.target.value.toUpperCase())} placeholder="A1B2C3"/><button className="outline-button" disabled={loading||!authenticated} onClick={()=>enter('join')}>دخول ←</button></div>{!configured&&<div className="notice">خاصك تضبط معلومات Supabase فـ Netlify.</div>}{configured&&!authenticated&&<div className="notice">كنربطو مع Supabase...</div>}</div>
   <div className="demo"><div className="demo-title"><span>⚡ جولة تجريبية</span><strong>فين كاينة المختلفة؟</strong></div><div className="demo-prompt">فين كاينة المختلفة؟</div><div className="products">{preview.map((id,i)=><div className="product" key={id}><img src={imageFor(id)} alt={`تجربة ${i+1}`}/><span>{String(i+1).padStart(2,'0')}</span></div>)}</div><div className="demo-foot"><span>جواب واحد صحيح</span><span>بلا بونيس ديال السرعة</span></div></div></section>
   <div className="features"><span><Users size={18}/> كل واحد كيجاوب بوحدو</span><span><ShieldCheck size={18}/> النقط كيتحسبو فالسيرفر</span><span><LockKeyhole size={18}/> غرفة خاصة</span></div>
  </main>:<main className="wrap match"><div className="match-title"><div><span className="eyebrow">مباراة خاصة · {code}</span><h1>فين كاينة المختلفة؟</h1></div><button className="exit" onClick={leave}>← خرج من المباراة</button></div>
   {!state?<div className="panel center">كنوجدو الغرفة...</div>:<>
    <div className="scorebar"><div className="player"><span>{state.is_host?'نتا':'المنافس'} · مول الغرفة</span><strong>{state.host_name}</strong><b>{state.host_score}<small> / {TOTAL}</small></b></div><div className="timer"><span><Timer size={15}/> {waiting?'قاعة الانتظار':countdown?'غادي نبداو':finished?'سالات':'الوقت الباقي'}</span><strong>{waiting?'--:--':secondsText(timeLeft)}</strong><small>{state.my_round}/{TOTAL} جاوبتي</small></div><div className="player"><span>{state.is_host?'المنافس':'نتا'} · الضيف</span><strong>{state.guest_name||'كنتسناو...'}</strong><b>{state.guest_score}<small> / {TOTAL}</small></b></div></div>
    {waiting?<section className="panel lobby"><div className="big-emoji">🤝</div><h2>الغرفة ديالك واجدة</h2><p>صيفط الرابط لصاحبك. كل واحد كيجاوب بوحدو. الصحيح نقطة، والغلط صفر.</p><div className="codeblock"><span>كود الدعوة</span><strong>{code}</strong><button className="outline-button" onClick={copyInvite}>{copied?<Check size={16}/>:<Copy size={16}/>} {copied?'تنسخ':'نسخ الرابط'}</button></div><div className="ready-players"><span>{state.host_name} · {state.host_ready?'✅ واجد':'⏳ مازال'}</span><span>{state.guest_name||'كنتسناو اللاعب الثاني'} · {state.guest_ready?'✅ واجد':'⏳ مازال'}</span></div><button className="gold-button lobby-ready" onClick={ready} disabled={loading||myReady||!state.guest_name}>{myReady?'✅ واجد ـ كنتسناو':"أنا واجد ←"}</button></section>:
     countdown?<div className="panel center"><div className="big-emoji">⚡</div><h2>وجد راسك!</h2><strong className="countdown-number">{timeLeft}</strong></div>:
     finished?<div className="panel result center"><div className="big-emoji">{winner==='win'?'🏆':winner==='draw'?'🤝':'🎯'}</div><h2>{winner==='win'?'ربحتي!':winner==='draw'?"تعادل!":'سالات المباراة!'}</h2><p>النقط ديالك: <b>{myScore}/{TOTAL}</b> · المنافس: <b>{rivalScore}/{TOTAL}</b></p><p>غير الأجوبة الصحيحة كيتحسبو. بلا نقاط إضافية على السرعة.</p><button className="gold-button" onClick={leave}><RotateCcw size={17}/> مباراة جديدة</button></div>:
     <section className="arena"><div className="round-header"><div><span>الجولة {Math.min((state.my_round??0)+1,TOTAL)} / {TOTAL} · {'تحدي الصور'}</span><h2>{'فين كاينة المختلفة؟'}</h2><p className="arabic-question" dir="rtl">{state.question_ar||'شكون مختلفة على الآخرين؟'}</p></div><div className="progress-circle">{Math.min((state.my_round??0)+1,TOTAL)}<small>/{TOTAL}</small></div></div>
      {(state.my_round??0)>=TOTAL?<div className="panel center"><div className="big-emoji">✨</div><h2>كملتي {TOTAL} جولة!</h2><p>النقط ديالك: {myScore}/{TOTAL}. صاحبك يقدر يكمل الأجوبة ديالو بوحدو.</p><p>النتيجة النهائية غتبان ملي تساليو بجوج ولا يسالي الوقت.</p></div>:<><div className="products game-products">{choices.map((id,i)=><button className={'product clickable '+(reveal?(i+1===reveal.answer?'right':i+1===reveal.choice?'wrong':''):'')} onClick={()=>pick(i+1)} disabled={!playing||!!reveal||busy.current} key={`${state.my_round}-${id}-${i}`}><img src={imageFor(id)} alt={`الاختيار ${i+1}`}/><span>{String(i+1).padStart(2,'0')}</span></button>)}</div>{reveal?<div className={'feedback '+(reveal.correct?'good':'bad')}><div><strong>{reveal.correct?'✅ برافو! +1 نقطة':'❌ ماشي هي ـ 0 نقطة'}</strong><p>الاختيار الصحيح: {reveal.answer}. {reveal.explanation}</p></div><button className="gold-button" onClick={nextQuestion}>السؤال اللي من بعد <ArrowRight size={16}/></button></div>:<p className="hint">اختار صورة وحدة. كل واحد كيجاوب بوحدو، والصحيح كيعطي نقطة وحدة.</p>}</>}
     </section>}
    </>}
  </main>}
  {error&&<div className="toast" role="alert">{error}<button onClick={()=>setError('')}>✕</button></div>}
  <footer>سبوت دويـل · بلا بونيس ديال السرعة · لعب نقي</footer>
 </div>
}
