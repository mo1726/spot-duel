import React from 'react'

// Original illustration; the right-hand scene includes exactly five visual differences.
// Hit locations are checked privately in PostgreSQL, not from the client.
export default function Scene({ variant = false, onPick, locked = false, claimed = [] }) {
  function pick(e) {
    if (!onPick || locked) return
    const bounds = e.currentTarget.getBoundingClientRect()
    onPick((e.clientX - bounds.left) / bounds.width, (e.clientY - bounds.top) / bounds.height)
  }
  return <div className={'scene '+(locked?'scene-locked':'')} onClick={pick} role={onPick?'button':'img'} aria-label="Colorful illustrated room. Find five differences between the pictures.">
    <svg viewBox="0 0 600 400" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none">
      <defs><linearGradient id={'sky'+variant} x1="0" x2="0" y1="0" y2="1"><stop stopColor="#a6def6"/><stop offset="1" stopColor="#e5f7fc"/></linearGradient></defs>
      <rect width="600" height="400" fill="#fae6d8"/>
      <rect y="306" width="600" height="94" fill="#d2a985"/><path d="M0 314H600" stroke="#a87964" strokeWidth="9"/>
      <rect x="56" y="42" width="198" height="178" rx="10" fill="#efe4d3" stroke="#f9f8ef" strokeWidth="12"/>
      <rect x="64" y="50" width="182" height="162" rx="3" fill={'url(#sky'+variant+')'}/>
      <path d="M64 165 Q115 118 163 161 T246 155 L246 212H64Z" fill="#9cceaa"/>
      <path d="M64 190 Q148 148 246 180V212H64Z" fill="#5db88e"/>
      {/* DIFFERENCE 1 - sun shape/color */}
      <circle cx="121" cy="91" r={variant?17:23} fill={variant?'#ffd078':'#ffb952'}/>
      {!variant && <g stroke="#ffbc59" strokeWidth="4" strokeLinecap="round"><path d="M121 58v-7M121 131v-7M88 91h-8M161 91h-8M96 66l-6-6M147 116l6 6M147 66l6-6M96 116l-6 6"/></g>}
      {/* DIFFERENCE 2 - cloud missing */}
      {!variant && <g fill="#fff"><circle cx="208" cy="93" r="15"/><circle cx="223" cy="85" r="19"/><circle cx="240" cy="94" r="14"/><rect x="206" y="92" width="36" height="13" rx="6"/></g>}
      <path d="M155 50V212" stroke="#fff" strokeWidth="9"/>
      <path d="M64 133H246" stroke="#fff" strokeWidth="8"/>
      <rect x="312" y="65" width="104" height="115" rx="12" fill="#cc8a6d"/>
      <rect x="324" y="76" width="80" height="91" rx="6" fill="#fbd39f"/>
      <path d="M334 148Q350 111 366 143T394 116" stroke="#6ba58e" strokeWidth="9" fill="none" strokeLinecap="round"/>
      <circle cx="366" cy="109" r="12" fill="#f6a0ab"/>
      <path d="M366 100v18M357 109h18" stroke="#fce5be" strokeWidth="3"/>
      {/* DIFFERENCE 3 - wall clock hands / central clock */}
      <circle cx="242" cy="210" r="32" fill="#fff9ee" stroke="#9a6281" strokeWidth="9"/>
      <circle cx="242" cy="210" r="3.6" fill="#433c58"/>
      <path d={variant?'M242 210V192M242 210L261 213':'M242 210V187M242 210L226 226'} fill="none" stroke="#433c58" strokeLinecap="round" strokeWidth="5"/>
      <rect x="115" y="255" width="295" height="86" rx="20" fill="#a36dba"/><rect x="105" y="243" width="310" height="69" rx="25" fill="#bd92d2"/>
      <rect x="116" y="234" width="78" height="61" rx="16" fill="#d8b2e7"/>
      <rect x="331" y="234" width="74" height="61" rx="16" fill="#d8b2e7"/>
      <rect x="195" y="267" width="125" height="35" rx="12" fill="#e8c7f1"/>
      <rect x="221" y="321" width="78" height="8" rx="4" fill="#7e508e"/>
      <ellipse cx="295" cy="364" rx="190" ry="30" fill="#eee1ae" stroke="#ddcb96" strokeWidth="7"/>
      {/* DIFFERENCE 5 - rug pattern */}
      {variant?<path d="M254 365L276 345L298 365L276 385Z" fill="#cc8fa9"/>:<g fill="#bc8db4"><circle cx="256" cy="365" r="10"/><circle cx="302" cy="365" r="10"/></g>}
      <rect x="425" y="285" width="132" height="12" rx="6" fill="#965f4b"/>
      <path d="M447 297L440 364M540 297l7 67" stroke="#965f4b" strokeWidth="9" strokeLinecap="round"/>
      <rect x="468" y="250" width="47" height="40" rx="6" fill="#c78b60"/>
      <path d="M490 253v-58" stroke="#458c60" strokeWidth="6" strokeLinecap="round"/>
      <path d="M490 225Q452 200 465 185Q481 184 490 213" fill="#60b56c"/>
      <path d="M490 218Q525 184 532 201Q524 219 490 231" fill="#49a96b"/>
      {/* DIFFERENCE 4 - flower color in vase */}
      <circle cx="490" cy="194" r="15" fill={variant?'#ffd56f':'#ff7695'}/>
      <circle cx="490" cy="194" r="6" fill="#fff2bc"/>
      <rect x="460" y="292" width="70" height="4" rx="2" fill="#7e4d3e"/>
      <path d="M0 402H600" stroke="#c39e7d" strokeWidth="2"/>
    </svg>
    {claimed.map(c=><span key={c.diff_id} className={'found-ring '+(c.is_mine?'mine':'theirs')} style={{left:(c.x*100)+'%',top:(c.y*100)+'%'}} aria-label="Found difference"/>)}
  </div>
}
