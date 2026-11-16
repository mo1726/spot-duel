import React from 'react'

export default function Scene({variant=false,onPick,locked=false,claimed=[]}) {
  function pick(e) {
    if (!onPick || locked) return
    const r=e.currentTarget.getBoundingClientRect()
    onPick((e.clientX-r.left)/r.width,(e.clientY-r.top)/r.height)
  }
  return <div className={'scene '+(locked?'scene-locked':'')} onClick={pick} role={onPick&&!locked?'button':'img'} tabIndex={onPick&&!locked?0:undefined} aria-label={variant?'Modified inventor studio illustration':'Original inventor studio illustration'}>
    <img src={variant?'/puzzles/study-modified.webp':'/puzzles/study-original.webp'} draggable="false" alt={variant?'Modified scene':'Original scene'} />
    {claimed.map(c=><span key={c.diff_id} className="found-ring mine" style={{left:(c.x*100)+'%',top:(c.y*100)+'%'}} aria-label="Found difference"/>)}
  </div>
}
