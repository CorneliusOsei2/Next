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
    const [currDay, setCurrDay] = useState(30)
    const [courses, setCourses] = useState([])
    const [currCourse, setCurrCourse] = useState({})

    /** TODO */
    const [user, setUser] = useState({"name": "Cornelius"})

    /** TODO */
    const [showTimeslots, setShowTimeslots] = useState(true)
    
    useEffect(
      () => getDays(month))
    
    useEffect(
      () => getCourses()
    )

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

    const getTimeslots = () =>{
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

    const getCourses = () => {
      fetch(`http://0.0.0.0:4500/next/${user.id}/courses/`, {
        "methods" : "GET",
        headers: {
            "Content-Type": "applications/json"
        }
        })
        .then(res => res.json())
        .then(res => setCourses(res.days))
        .catch(err => console.log(err))
    }

    const monthHandler = (e) => {
    setMonth(e.target.value);
    }

    const dayHandler = (e) => {
      let day_id = e.target.value
      getTimeslots(day_id)
      setCurrDay(day_id)
    }
  
    return (
        <div>

          <div className="greet-courses-div">
              <div className="greet-div">
                  Hi, <span className="greet-name">{user.name}</span>
              </div>

                <div>
                  {courses.map(course => {
                    return (
                      <Course name={course.name} code={course}></Course>
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

                <select onChange={dayHandler} name="days-select" id="" value={currDay}>
                  {days.map(dy => {
                    return (
                      <option><Day key={dy.id} id={dy.id} number={dy.number} active={dy.active}></Day></option> 
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

export default QueuePage;