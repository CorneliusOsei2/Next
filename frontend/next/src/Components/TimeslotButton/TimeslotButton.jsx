import React from 'react'
import { useState } from 'react'


const TimeslotButtons = ({state, handleJoinLeaveTimeslot}) => {

  const btn = {
    title:  state==="join"? "Join" : "Leave",
    class: state==="join"? "join-queue" : "leave-queue"
  }

  const handleTimeslotButton = (e) => {
    handleJoinLeaveTimeslot(e.target.innerHTML)
  }


  return (
    <button className={btn.class} onClick={handleTimeslotButton}>{btn.title}</button>
  )
}



export default TimeslotButtons
