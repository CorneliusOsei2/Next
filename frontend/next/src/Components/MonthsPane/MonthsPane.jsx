import { useState } from "react";
import "./monthspane.css"
import Month from "../Month/Month";
import Day from "../Day/Day";

const MonthsPane = () => {

    const [months, setMonths] = useState([]);
    const [days, setDays] = useState([])
  
    const genMonths = () => {
        fetch("http://0.0.0.0:4500/next/months/", {
        "methods" : "GET",
        headers: {
            "Content-Type": "applications/json"
        }
        })
        .then(res => res.json())
        .then(res => setMonths(res.months))
        .catch(err => console.log(err))
    };

    const getDays = (month_id) => {
      fetch(`http://0.0.0.0:4500/next/${month_id}/days/`, {
        "methods" : "GET",
        headers: {
            "Content-Type": "applications/json"
        }
        })
        .then(res => res.json())
        .then(res => setDays(res.days))
        .catch(err => console.log(err))
    }

    return (
        <div className="App">
          <header className="App-header">
            
            <button onClick={genMonths}>Months Bar</button>
            
              <div className='months-pane'>
                {months.map(mnth => {
                  return (
                    <Month id={mnth.id} name={mnth.name} getDays={getDays}></Month>
                )}
                )}
              </div>

              <div className='months-pane'>
                {days.map(dy => {
                  return (
                    <Day id={dy.id} number={dy.number} active={dy.active}></Day>
                  )}
                )}
              </div>





          </header>
        </div>
      );
}

export default MonthsPane;