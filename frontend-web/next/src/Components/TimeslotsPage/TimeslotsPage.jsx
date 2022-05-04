import { useState } from "react";
import "./timeslotspage.css"
import { useEffect } from "react";

// Components
import Timeslot from "../Timeslot/Timeslot"
import TimeslotButtons from "../TimeslotButton/TimeslotButton";

/**
 * 
 * event.timeStamp
 */

const TimeslotsPage = ({timeslots, handleDate}) => {

    const [days, setDays] = useState([])
    const [month, setMonth] = useState(4)
    const [day, setDay] = useState(30)
    const [courses, setCourses] = useState([])
   
    
    useEffect(() => getDays(month))
    
   
    const getDays = () => {
      
      fetch(`http://0.0.0.0:4500/next/${month}/days/`, {
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
      setMonth(e.target.value);
      handleDate(day, month);
    }

    const dayHandler = (e) => {
      setDay(e.target.value)
      handleDate(day, month)
    }
  
    return (
        <div>

          <div className="greet-courses-div">
              <div className="greet-div">
                  {/* Hi, <span className="greet-name">{user.name}</span> */}
              </div>

                <div>
                  {courses.map(course => {
                    return (
                      <div name={course.name} code={course}>tada</div>
                  )}
                  )}
                  
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
                  <option value="11">November</option>
                  <option value="12">December</option>
                </select>

                <select onChange={dayHandler} name="days-select" id="" value={day}>
                  {days.map(dy => {
                    return (
                      <option key={dy.id} value={dy.number} is_active={dy.active.toString()}>{dy.number}</option> 
                    )}
                  )}

                </select>
            </div>
          </div>
          
          <div className="col-md-9 timeslots-div row">
              
              <div className="col-md-3 timeslot">
              {timeslots.map(slot => {
                    return (
                      <div className="slot">
                          <div className="slot-top">{slot.start_time} - {slot.end_time}</div>
                          <div className="slot-mid">{slot.total_joined}</div>
                          <div className="slot-bottom"><TimeslotButtons></TimeslotButtons></div>
                      </div> 
                    )}
              )}

              </div>
              
             

          </div>
            
            



          </div>
        </div>
      );
}

export default TimeslotsPage;