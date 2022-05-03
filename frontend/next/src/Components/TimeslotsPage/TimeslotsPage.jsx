import { useState } from "react";
import "./timeslotspage.css"
import { useEffect } from "react";

// Components
<<<<<<< HEAD:frontend/next/src/Components/QueuePage/QueuePage.jsx
import Course from "../Course/Course"
=======
>>>>>>> 4eb435e1b04ea9f8481cb2058efce33674b57983:frontend/next/src/Components/TimeslotsPage/TimeslotsPage.jsx
import Timeslot from "../Timeslot/Timeslot"


const TimeslotsPage = ({handleDate}) => {

    const [days, setDays] = useState([])
    const [month, setMonth] = useState(4)
    const [day, setDay] = useState(30)
    const [courses, setCourses] = useState([])
   


    /** TODO */
    const [showTimeslots, setShowTimeslots] = useState(true)
    
    useEffect(
      () => getDays(month))
    
<<<<<<< HEAD:frontend/next/src/Components/QueuePage/QueuePage.jsx
    // useEffect(
    //   () => getCourses()
    // )

=======
   
>>>>>>> 4eb435e1b04ea9f8481cb2058efce33674b57983:frontend/next/src/Components/TimeslotsPage/TimeslotsPage.jsx
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


<<<<<<< HEAD:frontend/next/src/Components/QueuePage/QueuePage.jsx
   
=======

>>>>>>> 4eb435e1b04ea9f8481cb2058efce33674b57983:frontend/next/src/Components/TimeslotsPage/TimeslotsPage.jsx
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
<<<<<<< HEAD:frontend/next/src/Components/QueuePage/QueuePage.jsx
                      <option key={dy.id} value={dy.number}>{dy.number}</option> 
=======
                      <option key={dy.id} value={dy.number} is_active={dy.active.toString()}>{dy.number}</option> 
>>>>>>> 4eb435e1b04ea9f8481cb2058efce33674b57983:frontend/next/src/Components/TimeslotsPage/TimeslotsPage.jsx
                    )}
                  )}

                </select>
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

export default TimeslotsPage;