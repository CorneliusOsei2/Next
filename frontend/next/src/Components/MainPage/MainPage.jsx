
import TimeslotsPage from '../TimeslotsPage/TimeslotsPage';
import CoursesPage from "../CoursesPage/CoursesPage"

import { useState } from 'react';
import AddTimeslot from '../AddTimeslot/AddTimeslot';

const MainPage = () => {

    const [user, setUser] = useState({"id": "e2016d04-3812-4476-b796-fae436fd414d"})
    const [currMonth, setCurrMonth] = useState(4)
    const [currDay, setCurrDay] = useState(30)
    const [currCourse, setCurrCourse] = useState("1ecef47c-1632-4d78-a282-7652163f6baa")
    const [timeslots, setTimeslots] = useState([])
    const [slot, setSlot] = useState({})

    const [showCoursesPage, setShowCoursesPage] = useState(true)
    const [showTimeslotsPage, setShowTimeslotsPage] = useState(false)
    const [showAddTimeslot, setShowAddTimeslot] = useState(false)
    

    const handleShowTimesotsPage = (course_id) => {
        getTimeslots(course_id)
        setCurrCourse(course_id)
        setShowCoursesPage(!showCoursesPage)
        setShowTimeslotsPage(!showTimeslotsPage)
    }

    const getTimeslots = (course_id) => {
      fetch(`http://0.0.0.0:4500/next/${course_id}/${currMonth}/${currDay}/timeslots/`, {
        "methods" : "GET",
        headers: {
            "Content-Type": "applications/json"
        }
        })
        .then(res => res.json())
        .then(res => setTimeslots(res.timeslots))
        .catch(err => console.log(err))
    } 

    const addSlot = (slot) => {
        
        fetch(`localhost:4500/${currCourse}/add/`,
            {'method':'POST',
            headers : {
            'Content-Type':'application/json'
            },
            body:JSON.stringify(slot)
            })
        .then(response => response.json())
        .then(response => setSlot(response.timeslot))
        .catch(error => console.log(error))
    }
    

    const handleDate = (day, month) => {
        setCurrDay(day);
        setCurrMonth(month);
        getTimeslots(currCourse)
    }

    return(
        <div>

             {showCoursesPage && <CoursesPage user_id={user.id} showTimeslotsPage={handleShowTimesotsPage}></CoursesPage>}
             {showTimeslotsPage && <TimeslotsPage timeslots={timeslots} handleDate={handleDate}></TimeslotsPage>}
             {showAddTimeslot &&  <AddTimeslot addSlot={addSlot} slot={slot}></AddTimeslot>}
            
        </div>
    )
}


export default MainPage