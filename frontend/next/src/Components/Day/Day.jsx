import { useState } from "react";
import "./day.css"

const Day = ({id, number, active}) => {
    
  const day = {
    id, 
    number, 
    active
  }


    return (
      <button id={id} className="day">{day.number}</button>
      );
}

export default Day;