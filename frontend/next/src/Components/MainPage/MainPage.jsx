
import TimeslotsPage from '../TimeslotsPage/TimeslotsPage';
import CoursesPage from "../CoursesPage/CoursesPage"

import { useState } from 'react';

const MainPage = () => {

    const [user, setUser] = useState({"id": "e2016d04-3812-4476-b796-fae436fd414d"})
    const [currMonth, setCurrMonth] = useState(4)
    const [currDay, setCurrDay] = useState(30)
    const [currCourse, setCurrCourse] = useState("")
    const [timeslots, setTimeslots] = useState([])
    const [showCoursesPage, setShowCoursesPage] = useState(true)
    const [showTimeslotsPage, setShowTimeslotsPage] = useState(false)
    

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

    const handleDate = (day, month) => {
        setCurrDay(day);
        setCurrMonth(month);
        getTimeslots(currCourse)
    }

    return(
        <div className="container">

             {showCoursesPage && <CoursesPage user_id={user.id} showTimeslotsPage={handleShowTimesotsPage}></CoursesPage>}
             {showTimeslotsPage && <TimeslotsPage handleDate={handleDate}></TimeslotsPage>}
             
        </div>
    )
}


export default MainPage