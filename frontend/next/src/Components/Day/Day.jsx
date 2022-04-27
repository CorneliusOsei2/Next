import { useState } from "react";
import "./day.css"

const Day = () => {
    const [days, setDays] = useState([]);
  
    const genDays = () => {
        fetch("http://0.0.0.0:4500/next/days/", {
        "methods" : "GET",
        headers: {
            "Content-Type": "applications/json"
        }
        })
        .then(res => res.json())
        .then(res => setDays(res.days))
        .catch(err => console.log(err))
    };

    return (
        <div className="App">
          <header className="App-header">
            
            <button onClick={genDays}>Days Bar</button>
            
              <div className='days-scroll'>
                {days.map(day => {
                  return (
                    <button className="day" key={day.id}> {day.number} </button>
                )}
                )}
            </div>
          </header>
        </div>
      );
}

export default Day;