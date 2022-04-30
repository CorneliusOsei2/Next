import { useState } from "react";
import "./queuepage.css"
import { useEffect } from "react";

// Components
import Day from "../Day/Day";
import Course from "../Course/Course"
import Timeslot from "../Timeslot/Timeslot"


const QueuePage = () => {

    const [days, setDays] = useState([])
    const [month, setMonth] = useState(4)
    const [user, setUser] = useState("")
    
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

          <div className="greet-courses-div">
              <div className="greet-div">
                  Hi,  Cornelius
              </div>

                <div>
                  <Course></Course>
                </div>
          </div>
             

          <div className="row">

            <div className="col-md-3">
              <div className="date-div">
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


                  {days.map(dy => {
                    return (
                      <Day key={dy.id} id={dy.id} number={dy.number} active={dy.active}></Day>
                    )}
                  )}
            </div>
          </div>
          
          <div className="col-md-9 timeslots-div">
              
              <div className="col-md-3 timeslot">
                <Timeslot></Timeslot>
              </div>
              
             

          </div>
            
            



          </div>
        </div>
      );
}

export default QueuePage;