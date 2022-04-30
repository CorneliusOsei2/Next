import React from 'react'
import { useState } from 'react'
import "./timeslotbuttons.css"


const TimeslotButtons = ({state, handleJoinLeaveTimeslot}) => {

  const btn = {
    title:  state==="join"? "Join" : "Leave",
    class: state==="join"? "btn shadow-none join-queue btn-success" : "btn shadow-none leave-queue btn-danger"
  }

  const handleTimeslotButton = (e) => {
    handleJoinLeaveTimeslot(e.target.innerHTML)
  }


  return (
    <button className={btn.class} onClick={handleTimeslotButton}>{btn.title}</button>
  )
}



export default TimeslotButtons
