import React from 'react'

const brown='#623221',gold='#ffcf73'
function TilePicture({kind,odd}){
 const dots=(coords,fill,r=5)=>coords.map(([x,y],i)=><circle key={i} cx={x} cy={y} r={r} fill={fill}/>)
 const chips=[[75,70],[103,49],[139,82],[108,111],[66,120],[145,127],[121,154]]
 const fruitBg=<circle cx="110" cy="105" r="80" fill="#f1f4f0" />
 let art
 switch(kind){
 case 0: art=<g transform="rotate(-13 110 110)">
  <rect x="56" y="21" width="108" height="176" rx="8" fill="#2e180f"/>
  {Array.from({length:4},(_,i)=>Array.from({length:3},(_,j)=>{
   const missing=odd&&i===2&&j===1
   return <g key={i+'-'+j}><rect x={63+j*32} y={29+i*41} width="27" height="35" rx="3" fill={missing?'#9a6044':'#7b4130'} stroke="#3f1e18" strokeWidth="2"/><path d={`M${66+j*32} ${32+i*41}h20l-5 4h-13z`} fill={missing?'#b87a59':'#a75e43'}/></g>
  }))}
 </g>;break
 case 1: art=<g><path d="M60 116 L160 116 L147 183 Q110 199 73 183Z" fill="#c78b54"/>{Array.from({length:10},(_,i)=><path key={i} d={`M${70+i*8} 125l5 55`} stroke="#a76539" strokeWidth="2"/>)}<path d="M55 118Q40 95 64 82Q51 62 78 58Q69 39 102 40Q113 21 133 43Q158 37 153 64Q181 78 158 99Q172 119 148 121Z" fill="#bfe9ab" stroke="#8dc28b" strokeWidth="3"/><path d="M62 106 Q105 85 147 105 M76 77 Q107 63 142 78" fill="none" stroke="#eef9d5" strokeWidth="9" strokeLinecap="round"/>{dots(odd?[[86,88],[124,62],[148,95]]:[[86,88],[124,62],[148,95],[106,104]],'#b85656',4)}</g>;break
 case 2: art=<g>{fruitBg}<circle cx="110" cy="105" r="70" fill="#ba8245" stroke="#89522f" strokeWidth="5"/>{dots(odd?chips.slice(0,-1):chips,'#5d3429',7)}{dots([[91,85],[139,104],[87,151]],'#e8ae68',4)}</g>;break
 case 3: art=<g>{fruitBg}<circle cx="110" cy="106" r="73" fill="#eaa2c1"/><circle cx="110" cy="106" r="33" fill="#f1f4f0"/><path d="M53 80 Q90 35 152 57" fill="none" stroke="#ffccdf" strokeWidth="8"/>{dots([[62,110],[79,65],[148,77],[157,133],[93,159],[132,157]].filter((_,i)=>!odd||i!==3),'#db5185',5)}</g>;break
 case 4: art=<g><path d="M60 98L160 98L110 190Z" fill="#dfa663" stroke="#af733d" strokeWidth="4"/>{Array.from({length:5},(_,i)=><path key={i} d={`M${65+i*20} ${106+i*0}L${111} 185`} stroke="#b87b41" strokeWidth="2"/>)}<path d="M60 100Q37 75 69 59Q63 33 95 34Q111 15 133 38Q167 32 164 64Q183 87 155 101Z" fill="#e9c3e9" stroke="#b786c3" strokeWidth="4"/>{dots(odd?[[88,60],[128,74],[98,84]]:[[88,60],[128,74],[98,84],[148,58]],'#e84c8b',4)}</g>;break
 case 5: art=<g><path d="M110 52Q155 36 165 94Q181 152 109 181Q35 150 56 92Q67 43 110 52Z" fill="#ed4a5d" stroke="#b92d43" strokeWidth="4"/><path d="M109 55L93 29L112 37L126 22L130 43L152 36L133 62" fill="#65a963" stroke="#357b4c" strokeWidth="4"/>{dots(odd?[[83,87],[122,91],[99,125],[142,131],[76,148]]:[[83,87],[122,91],[99,125],[142,131],[76,148],[115,151]],'#ffe5b0',4)}</g>;break
 case 6: art=<g><path d="M108 28Q185 28 177 123Q176 177 112 187Q48 177 43 119Q36 33 108 28Z" fill="#548d58"/><path d="M109 43Q167 44 159 120Q155 163 111 169Q62 163 60 115Q57 45 109 43Z" fill="#d5efaa"/><circle cx="108" cy="122" r={odd?27:33} fill="#9c6947" stroke="#67432f" strokeWidth="6"/><circle cx="101" cy="111" r="9" fill="#c39169" opacity=".6"/></g>;break
 case 7: art=<g><rect x="44" y="70" width="132" height="77" rx="35" fill="#cd7da3" stroke="#965475" strokeWidth="4"/><rect x="42" y="90" width="136" height={odd?15:21} rx="9" fill="#f6ddce"/><rect x="44" y="66" width="132" height="38" rx="18" fill="#eaa7c4"/><rect x="44" y="110" width="132" height="38" rx="18" fill="#eaa7c4"/><path d="M66 83h88 M65 128h90" stroke="#f7c4d9" strokeWidth="5" strokeLinecap="round"/></g>;break
 case 8: art=<g>{fruitBg}<ellipse cx="110" cy="108" rx="77" ry={odd?51:59} transform="rotate(-28 110 108)" fill="#f9d84e" stroke="#debd27" strokeWidth="5"/><path d="M54 139Q96 76 165 72" fill="none" stroke="#fff2a4" strokeWidth="6" strokeLinecap="round"/><path d="M57 142l-14 7M165 72l13-7" stroke="#91ad4b" strokeWidth="7" strokeLinecap="round"/></g>;break
 default: art=<g><path d="M109 35L188 174Q110 207 32 174Z" fill="#e8b16b" stroke="#bd8244" strokeWidth="6"/><path d="M108 48L173 164Q107 190 47 165Z" fill="#f9d76d"/>{dots(odd?[[103,88],[83,131],[137,139]]:[[103,88],[83,131],[137,139],[109,162]],'#c9464b',12)}{dots([[133,109],[77,151]],'#4d9a59',8)}<path d="M32 174Q108 204 188 174" fill="none" stroke="#9b663f" strokeWidth="13" strokeLinecap="round"/></g>
 }
 return <svg viewBox="0 0 220 220" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Food illustration">{art}</svg>
}
export default TilePicture
