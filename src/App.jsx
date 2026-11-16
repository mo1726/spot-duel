import React, { useCallback, useEffect, useRef, useState } from 'react'
import { ArrowRight, Check, Copy, Gamepad2, LoaderCircle, Play, ShieldCheck, Swords, Users, Trophy, Timer, RotateCcw, Sparkles, LockKeyhole } from 'lucide-react'
import { configured, supabase } from './supabase'

const TOTAL=20
const fromUrl=()=>new URLSearchParams(window.location.search).get('room')?.toUpperCase() || ''
const stamp=v=>v?new Date(v).getTime():null
const imageFor=id=>`/products/${id}.webp`
const secondsText=s=>`${String(Math.floor(s/60)).padStart(2,'0')}:${String(s%60).padStart(2,'0')}`
const preview=['cream-2','cream-4','shampoo-2','cream-5']

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
  if(!authenticated){setError('Connection not ready. Enable anonymous sign-ins in Supabase.');return}
  if(name.trim().length<1||name.trim().length>20){setError('Choose a name from 1 to 20 characters.');return}
  if(kind==='join'&&!/^[A-F0-9]{6}$/.test(joinCode.trim().toUpperCase())){setError('Please enter a six-character room code.');return}
  setLoading(true)
  try{
   localStorage.setItem('spot-name',name.trim())
   const {data,error:e}=await supabase.rpc(kind==='create'?'duel_create':'duel_join',kind==='create'?{p_name:name.trim()}:{p_code:joinCode.trim().toUpperCase(),p_name:name.trim()})
   if(e)throw e
   current.current=data;setCode(data);setState(null);setReveal(null)
   window.history.replaceState(null,'','?room='+encodeURIComponent(data))
  }catch(e){setError(e.message||'Could not enter room')}finally{setLoading(false)}
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
   if(data?.result!=='answered'){revealLock.current=false;setError('This round is not currently active.');await refresh(code);return}
   setReveal({correct:data.correct,answer:data.correct_choice,choice:n,explanation:data.explanation,round:state.my_round+1})
  }catch(e){revealLock.current=false;setError(e.message||'Could not save answer');await refresh(code)}finally{busy.current=false}
 }
 async function nextQuestion(){setReveal(null);revealLock.current=false;await refresh(code)}
 function leave(){revealLock.current=false;setReveal(null);setCode('');setState(null);current.current='';setError('');window.history.replaceState(null,'',window.location.pathname)}
 async function copyInvite(){try{await navigator.clipboard.writeText(location.origin+'/?room='+code);setCopied(true);setTimeout(()=>setCopied(false),1200)}catch{setError('Copy failed. Share the room code instead.')}}
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
  <header className="topbar wrap"><div className="logo"><div className="logo-icon">⚡</div><strong>SPOT<span>DUEL</span></strong><small>مين المختلفة؟</small></div><div className="live"><i/> LIVE MULTIPLAYER <span>· 2 PLAYERS</span></div></header>
  {!code?<main className="wrap home">
   <section className="hero"><div className="eyebrow"><Sparkles size={15}/> THE ODD ONE OUT CHALLENGE</div><h1>مين <em>المختلفة؟</em></h1><h2>4 PRODUCTS. 1 ODD ONE OUT.</h2><p>Play the viral-style visual challenge against a friend. Realistic product images, category questions, 20 rounds and no speed bonus. <strong>Think first, tap once.</strong></p><div className="chips"><span>🎯 120 PUZZLES</span><span>📸 36 PRODUCT PHOTOS</span><span>🕹️ PRIVATE 1V1</span></div></section>
   <section className="home-layout"><div className="panel start-panel"><div className="section-label"><Gamepad2 size={21}/> START YOUR DUEL</div><label>Your player name</label><input value={name} maxLength={20} onChange={e=>setName(e.target.value)} placeholder="e.g. PlayerOne"/><button className="gold-button" disabled={loading||!authenticated} onClick={()=>enter('create')}>{loading?<LoaderCircle className="spin" size={18}/>:<Play size={18}/>} CREATE PRIVATE ROOM <ArrowRight size={18}/></button><div className="separation">OR JOIN A FRIEND</div><label>6-digit invitation code</label><div className="join"><input maxLength={6} value={joinCode} onChange={e=>setJoinCode(e.target.value.toUpperCase())} placeholder="A1B2C3"/><button className="outline-button" disabled={loading||!authenticated} onClick={()=>enter('join')}>JOIN →</button></div>{!configured&&<div className="notice">Set VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY in Netlify environment variables.</div>}{configured&&!authenticated&&<div className="notice">Connecting to Supabase...</div>}</div>
   <div className="demo"><div className="demo-title"><span>⚡ DEMO ROUND</span><strong>مين المختلفة؟</strong></div><div className="demo-prompt">Which one is NOT a skin cream?</div><div className="products">{preview.map((id,i)=><div className="product" key={id}><img src={imageFor(id)} alt={`Demo product ${i+1}`}/><span>{String(i+1).padStart(2,'0')}</span></div>)}</div><div className="demo-foot"><span>ONE CORRECT ANSWER</span><span>NO SPEED BONUS</span></div></div></section>
   <div className="features"><span><Users size={18}/> INDEPENDENT ANSWERS</span><span><ShieldCheck size={18}/> SERVER-VERIFIED SCORES</span><span><LockKeyhole size={18}/> PRIVATE ROOM</span></div>
  </main>:<main className="wrap match"><div className="match-title"><div><span className="eyebrow">PRIVATE MATCH · {code}</span><h1>مين المختلفة؟</h1></div><button className="exit" onClick={leave}>← LEAVE MATCH</button></div>
   {!state?<div className="panel center">Loading room...</div>:<>
    <div className="scorebar"><div className="player"><span>{state.is_host?'YOU':'OPPONENT'} · HOST</span><strong>{state.host_name}</strong><b>{state.host_score}<small> / {TOTAL}</small></b></div><div className="timer"><span><Timer size={15}/> {waiting?'LOBBY':countdown?'STARTING':finished?'FINISHED':'TIME LEFT'}</span><strong>{waiting?'--:--':secondsText(timeLeft)}</strong><small>{state.my_round}/{TOTAL} ANSWERED</small></div><div className="player"><span>{state.is_host?'OPPONENT':'YOU'} · GUEST</span><strong>{state.guest_name||'Waiting...'}</strong><b>{state.guest_score}<small> / {TOTAL}</small></b></div></div>
    {waiting?<section className="panel lobby"><div className="big-emoji">🤝</div><h2>YOUR PRIVATE ARENA IS READY</h2><p>Share the link with a friend. Each person answers separately. Correct answer = one point, wrong answer = zero.</p><div className="codeblock"><span>INVITATION CODE</span><strong>{code}</strong><button className="outline-button" onClick={copyInvite}>{copied?<Check size={16}/>:<Copy size={16}/>} {copied?'COPIED':'COPY INVITE'}</button></div><div className="ready-players"><span>{state.host_name} · {state.host_ready?'✅ Ready':'⏳ Not ready'}</span><span>{state.guest_name||'Waiting for player 2'} · {state.guest_ready?'✅ Ready':'⏳ Not ready'}</span></div><button className="gold-button lobby-ready" onClick={ready} disabled={loading||myReady||!state.guest_name}>{myReady?'✅ READY — WAITING':"I'M READY →"}</button></section>:
     countdown?<div className="panel center"><div className="big-emoji">⚡</div><h2>GET READY!</h2><strong className="countdown-number">{timeLeft}</strong></div>:
     finished?<div className="panel result center"><div className="big-emoji">{winner==='win'?'🏆':winner==='draw'?'🤝':'🎯'}</div><h2>{winner==='win'?'YOU WIN!':winner==='draw'?"IT'S A DRAW!":'MATCH OVER!'}</h2><p>Your score: <b>{myScore}/{TOTAL}</b> · Opponent: <b>{rivalScore}/{TOTAL}</b></p><p>Only correct answers count. No speed bonus.</p><button className="gold-button" onClick={leave}><RotateCcw size={17}/> NEW MATCH</button></div>:
     <section className="arena"><div className="round-header"><div><span>ROUND {Math.min((state.my_round??0)+1,TOTAL)} / {TOTAL} · {state.category?.toUpperCase()}</span><h2>{state.question||'Which one is different?'}</h2><p className="arabic-question" dir="rtl">{state.question_ar||'مين المختلفة؟'}</p></div><div className="progress-circle">{Math.min((state.my_round??0)+1,TOTAL)}<small>/{TOTAL}</small></div></div>
      {(state.my_round??0)>=TOTAL?<div className="panel center"><div className="big-emoji">✨</div><h2>ALL {TOTAL} ANSWERED!</h2><p>Your score: {myScore}/{TOTAL}. Your opponent can finish separately.</p><p>The final result will appear after both players finish or the timer ends.</p></div>:<><div className="products game-products">{choices.map((id,i)=><button className={'product clickable '+(reveal?(i+1===reveal.answer?'right':i+1===reveal.choice?'wrong':''):'')} onClick={()=>pick(i+1)} disabled={!playing||!!reveal||busy.current} key={`${state.my_round}-${id}-${i}`}><img src={imageFor(id)} alt={`Product choice ${i+1}`}/><span>{String(i+1).padStart(2,'0')}</span></button>)}</div>{reveal?<div className={'feedback '+(reveal.correct?'good':'bad')}><div><strong>{reveal.correct?'✅ CORRECT! +1 POINT':'❌ NOT QUITE — +0 POINTS'}</strong><p>Correct option: {reveal.answer}. {reveal.explanation}</p></div><button className="gold-button" onClick={nextQuestion}>NEXT QUESTION <ArrowRight size={16}/></button></div>:<p className="hint">Choose only one product. Both players answer independently, and the right answer scores exactly 1 point.</p>}</>}
     </section>}
    </>}
  </main>}
  {error&&<div className="toast" role="alert">{error}<button onClick={()=>setError('')}>✕</button></div>}
  <footer>SPOT DUEL · NO SPEED BONUS · PLAY FAIR · MADE FOR THE WEB</footer>
 </div>
}
