import { useState } from "react";
import "./monthspane.css"
import Month from "../Month/Month";
import Day from "../Day/Day";
import { useEffect } from "react";

const MonthsPane = () => {

    const [days, setDays] = useState([])
    const [month, setMonth] = useState(4)
    
    useEffect(
      () => getDays(month)
    , [month])

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

    const monthHandler = (e) => {
      let month_id = e.target.value
      console.log(month_id)
      getDays(month_id)
      setMonth(month_id);
    }

    
   
    
    return (
        <div>
          <header>
                        
              <select onChange={monthHandler} value={month} id="months-select">
                <option value="1">January</option>
                <option value="2">February</option>
                <option value="3">March</option>
                <option value="4">April</option>
                <option value="5">May</option>
                <option value="6">June</option>
                <option value="7">July</option>
                <option value="8">August</option>
                <option value="9">September</option>
                <option value="10">October</option>
              </select>


              <div className='days-pane'>
                {days.map(dy => {
                  return (
                    <Day key={dy.id} id={dy.id} number={dy.number} active={dy.active}></Day>
                  )}
                )}
              </div>





          </header>
        </div>
      );
}

export default MonthsPane;