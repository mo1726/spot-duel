import React, { useCallback, useEffect, useRef, useState } from 'react'
import { ArrowRight, Check, Copy, Gamepad2, Link as LinkIcon, LoaderCircle, Play, ShieldCheck, Swords, Users, Zap } from 'lucide-react'
import { configured, supabase } from './supabase'
import TilePicture from './OddArt'

const ROUNDS = [
 ['CHOCOLATE', 'Find the different chocolate'],
 ['CUPCAKES', 'Which cupcake is different?'],
 ['COOKIES', 'One cookie has changed'],
 ['DONUTS', 'Look closely at the sprinkles'],
 ['ICE CREAM', 'Which ice cream is different?'],
 ['STRAWBERRIES', 'One strawberry is not the same'],
 ['AVOCADOS', 'Spot the odd avocado'],
 ['MACARONS', 'One macaron has changed'],
 ['LEMONS', 'Which lemon is different?'],
 ['PIZZA', 'One slice is hiding a difference']
]
const ODD_CHOICES = [2,3,1,4,2,1,3,4,1,2]
const codeFromUrl = () => new URLSearchParams(window.location.search).get('room')?.toUpperCase() || ''
const stamp = v => v ? new Date(v).getTime() : null

export default function App() {
  const [name,setName] = useState(localStorage.getItem('spot-name') || '')
  const [joinCode,setJoinCode] = useState(codeFromUrl())
  const [code,setCode] = useState('')
  const [state,setState] = useState(null)
  const [now,setNow] = useState(Date.now())
  const [error,setError] = useState('')
  const [message,setMessage] = useState('')
  const [loading,setLoading] = useState(false)
  const [authenticated,setAuthenticated] = useState(false)
  const [copied,setCopied] = useState(false)
  const pendingPick = useRef(false)
  const currentCode = useRef('')

  useEffect(()=>{
    if (!configured) return
    let mounted=true
    async function auth(){
      const {data:{session},error:sessionError} = await supabase.auth.getSession()
      if (!mounted) return
      if(sessionError) {setError(sessionError.message);return}
      if (session) {setAuthenticated(true);return}
      const {error:signError}=await supabase.auth.signInAnonymously()
      if(mounted) {if(signError)setError(signError.message); else setAuthenticated(true)}
    }
    auth()
    return ()=>{mounted=false}
  },[])

  const refresh=useCallback(async (roomCode)=>{
    if(!roomCode || !supabase) return
    const {data,error:err}=await supabase.rpc('duel_state',{p_code:roomCode})
    if (!err && currentCode.current === roomCode) setState(data)
  },[])

  useEffect(()=>{
    currentCode.current=code
    if(!code || !supabase) return
    refresh(code)
    const channel=supabase.channel('duel-'+code).on('postgres_changes',{
      event:'UPDATE',schema:'public',table:'duel_rooms'
    },(payload)=>{if (payload.new.code===code)refresh(code)}).subscribe()
    const poll=setInterval(()=>refresh(code),2000)
    return ()=>{clearInterval(poll);supabase.removeChannel(channel)}
  },[code,refresh])

  useEffect(()=>{const tick=setInterval(()=>setNow(Date.now()),250);return()=>clearInterval(tick)},[])

  async function enter(kind){
    setError('');setMessage('')
    if(!authenticated){setError('Supabase connection is not ready. Check Anonymous Sign-Ins.');return}
    if(name.trim().length<1 || name.trim().length>20){setError('Choose a name (1–20 characters).');return}
    if(kind==='join' && !/^[A-F0-9]{6}$/.test(joinCode.trim().toUpperCase())){setError('Enter a valid 6-character room code.');return}
    setLoading(true)
    try {
      localStorage.setItem('spot-name',name.trim())
      const {data,error:err}= await supabase.rpc(kind==='create'?'duel_create':'duel_join',kind==='create'?{p_name:name.trim()}:{p_code:joinCode.trim().toUpperCase(),p_name:name.trim()})
      if(err)throw err
      currentCode.current=data
      setState(null);setCode(data)
      window.history.replaceState(null,'','?room='+encodeURIComponent(data))
    }catch(e){setError(e.message || 'Unexpected error')}finally{setLoading(false)}
  }

  async function ready(){
    setError('');setLoading(true)
    const {error:err}=await supabase.rpc('duel_ready',{p_code:code})
    if(err)setError(err.message)
    else await refresh(code)
    setLoading(false)
  }

  async function pick(choice){
    if(pendingPick.current || !state || state.my_round>=10)return
    pendingPick.current=true
    setMessage('')
    try {
      const {data,error:err}=await supabase.rpc('duel_choose',{p_code:code,p_round:state.my_round+1,p_choice:choice})
      if(err)throw err
      setMessage(data.correct?'Correct! +1 point':'Not this one. Next puzzle!')
      await refresh(code)
    } catch(e){setError(e.message)} finally{pendingPick.current=false}
  }

  function copyInvite(){
    navigator.clipboard?.writeText(window.location.origin+'/?room='+code)
    setCopied(true);setTimeout(()=>setCopied(false),1500)
  }
  function leave(){setCode('');setState(null);currentCode.current='';window.history.replaceState(null,'',window.location.pathname);setError('');setMessage('')}

  const start=stamp(state?.started_at),end=stamp(state?.ends_at)
  const waiting= Boolean(state && !start)
  const countdown=Boolean(start && now<start)
  const playing=Boolean(start && now>=start && now<end && (state?.my_round??10)<10)
  const finished=Boolean(start && (now>=end || (state?.host_finished_at && state?.guest_finished_at)))
  const timeLeft=Math.max(0,Math.ceil(((countdown?start:end)||now)-now)/1000)
  const mine=state?.is_host?'host':'guest'
  const myReady=state?.[mine+'_ready']
  const myScore=state?.[mine+'_score'] || 0
  const rivalScore=state?.[(mine==='host'?'guest':'host')+'_score'] || 0
  const myFinish=stamp(state?.[mine+'_finished_at'])
  const rivalFinish=stamp(state?.[(mine==='host'?'guest':'host')+'_finished_at'])
  const winner=finished?(myScore===rivalScore?'draw':myScore>rivalScore?'win':'lose'):null
  const round=Math.min(state?.my_round??0,9)

  return <div className="app">
    <header className="nav wrap"><div className="brand"><div className="brand-mark"><Swords size={21}/></div><span>SPOT<span className="accent">DUEL</span></span></div><div className="nav-pill"><span className="live-dot"/> 2 PLAYER ONLINE GAME</div></header>
    {!code ? <main className="wrap landing">
      <section className="hero"><div className="eyebrow"><Zap size={14}/> A NEW KIND OF VISUAL DUEL</div><h1>Four pictures.<br/><span>One is different.</span></h1><p>The viral “مين المختلفة” challenge — now a private 1v1 duel. Ten tricky food puzzles. Choose the odd one out, on your own. Most correct answers wins.</p></section>
      <section className="home-grid"><div className="panel room-panel"><div className="panel-heading"><Gamepad2 size={22}/><span>PLAY WITH A FRIEND</span></div>
        <label>Your nickname</label><input maxLength={20} value={name} onChange={e=>setName(e.target.value)} placeholder="Enter your player name" />
        <button className="primary full" disabled={loading||!authenticated} onClick={()=>enter('create')}>{loading?<LoaderCircle className="spin"/>:<Play size={19} fill="currentColor"/>} CREATE PRIVATE ROOM <ArrowRight size={18}/></button>
        <div className="or"><span>OR JOIN AN EXISTING MATCH</span></div>
        <label>Invite code</label><div className="join-row"><input maxLength={6} value={joinCode} onChange={e=>setJoinCode(e.target.value.toUpperCase())} placeholder="E.G. A1B2C3"/><button className="secondary" disabled={loading||!authenticated} onClick={()=>enter('join')}>JOIN <ArrowRight size={17}/></button></div>
        {!configured&&<div className="alert">Setup required: copy .env.example to .env and add your Supabase project URL and publishable key.</div>}
        {configured&&!authenticated&&<p className="muted small">Connecting to game services...</p>}
      </div><div className="preview-panel"><div className="preview-heading"><span className="small-tag">HARD MODE</span><span>مين المختلفة؟</span></div><div className="preview-four">{[1,2,3,4].map(n=><div className="preview-tile" key={n}><TilePicture kind={1} odd={n===3}/></div>)}</div><div className="preview-footer"><span>🔎 10 TRICKY PUZZLES</span><span>⏱ 120 SECONDS</span><span>🏆 NO SPEED BONUS</span></div></div></section>
      <div className="features"><span><Users size={16}/> INDEPENDENT 1V1</span><span><ShieldCheck size={16}/> VERIFIED SCORES</span><span><LinkIcon size={16}/> INVITE BY LINK</span></div>
    </main> : <main className="wrap game-main">
      <div className="game-header"><div><div className="eyebrow">PRIVATE MATCH</div><h1><span>مين المختلفة؟</span></h1></div><button className="text-button" onClick={leave}>← LEAVE ROOM</button></div>
      {state?<>
        <div className="scoreboard"><div className="player-score"><div className="player-label">{state.is_host?'YOU':'OPPONENT'} · HOST</div><strong>{state.host_name}</strong><b>{state.host_score}<small> / 10 CORRECT</small></b></div>
          <div className="game-clock"><span>{finished?'MATCH ENDED':waiting?'WAITING':countdown?'GET READY':'TIME LEFT'}</span><strong>{waiting?'--:--':`${String(Math.floor(timeLeft/60)).padStart(2,'0')}:${String(timeLeft%60).padStart(2,'0')}`}</strong><small>{state.my_round} / 10 ANSWERED</small></div>
          <div className="player-score right"><div className="player-label">{state.is_host?'OPPONENT':'YOU'} · GUEST</div><strong>{state.guest_name||'Waiting for opponent...'}</strong><b>{state.guest_score}<small> / 10 CORRECT</small></b></div></div>
        {waiting?<section className="lobby panel"><div className="lobby-icon"><Users size={28}/></div><h2>Ready for the odd-one-out duel?</h2><p>Invite a friend. Each player solves 10 puzzles independently. One answer per round. Only correct answers count, never tapping speed.</p><div className="code-box"><span>ROOM CODE</span><strong>{code}</strong><button onClick={copyInvite}>{copied?<Check size={17}/>:<Copy size={17}/>} {copied?'COPIED':'COPY LINK'}</button></div>
          <div className="ready-status"><span>{state.host_name} {state.host_ready?'✅ READY':'⌛ NOT READY'}</span><span>{state.guest_name||'Waiting for player 2...'} {state.guest_ready?'✅ READY':''}</span></div>
          <button className="primary" onClick={ready} disabled={loading||myReady||!state.guest_name}>{myReady?'✅ WAITING FOR OPPONENT':<><Check size={18}/> I'M READY</>}</button>
        </section>:<><div className="round-top"><span>10 PUZZLES · HARD MODE</span><span>YOUR ANSWERS ARE INDEPENDENT</span></div>
          {(playing||(!finished&&start&&now>=start))&&<section className="odd-panel">
             {(state.my_round??0)<10 ? <>
               <div className="odd-heading"><div><span className="stage-label">{ROUNDS[round][0]} · ROUND {round+1}/10</span><h2>{ROUNDS[round][1]}</h2><p>مين المختلفة؟ · Choose ONE picture</p></div><div className="round-counter">{round+1}<small>/10</small></div></div>
               <div className="odd-grid">{[1,2,3,4].map(n=><button type="button" key={`${round}-${n}`} disabled={!playing||pendingPick.current} className="odd-tile" onClick={()=>pick(n)} aria-label={`Choose picture ${n}`}><TilePicture kind={round} odd={n===ODD_CHOICES[round]}/><span className="tile-number">{String(n).padStart(2,'0')}</span></button>)}</div>
               <p className="odd-note">Look very closely. Only one detail is different.</p>
             </>:<div className="result"><div className="result-emoji">✨</div><h2>ALL 10 ANSWERED!</h2><p>You scored {myScore}/10. Your opponent can finish independently.</p></div>}
           </section>}
          {countdown&&<div className="info-bar">Get ready! Match starts in <strong>{timeLeft}</strong>...</div>}
          {playing&&<div className="info-bar">{message||'One choice per round. No speed bonus. Most correct answers wins!'}</div>}
          {finished&&<div className="result"><div className="result-emoji">{winner==='win'?'🏆':winner==='lose'?'🎯':'🤝'}</div><h2>{winner==='win'?'YOU WON!':winner==='lose'?'NICE TRY!':'IT’S A DRAW!'}</h2><p>You answered {myScore}/10 correctly · Opponent: {rivalScore}/10. No time bonus.</p><button className="primary" onClick={leave}>PLAY ANOTHER MATCH <ArrowRight size={18}/></button></div>}
        </>}
      </>:<div className="panel loading">Connecting to room...</div>}
    </main>}
    {error&&<div className="toast" role="alert">{error}<button onClick={()=>setError('')}>✕</button></div>}
    <footer className="footer">SPOTDUEL · MADE FOR FRIENDLY COMPETITION · NO DOWNLOAD REQUIRED</footer>
  </div>
}
