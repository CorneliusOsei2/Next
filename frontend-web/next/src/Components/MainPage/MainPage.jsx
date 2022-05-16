
import TimeslotsPage from '../TimeslotsPage/TimeslotsPage';
import CoursesPage from "../CoursesPage/CoursesPage"

import { useState } from 'react';
import AddTimeslot from '../AddTimeslot/AddTimeslot';
import TopSideBars from '../TopSideBars/TopSideBars';

import "./mainpage.css"
const MainPage = () => {

    // const [user, setUser] = useState({"id": "426513b5-47be-4266-80c4-f2e495138689"})
    // const [currMonth, setCurrMonth] = useState(4)
    // const [currDay, setCurrDay] = useState(30)
    // const [currCourse, setCurrCourse] = useState("1ecef47c-1632-4d78-a282-7652163f6baa")
    // const [timeslots, setTimeslots] = useState([])
    // const [slot, setSlot] = useState({})

    // const [showCoursesPage, setShowCoursesPage] = useState(true)
    // const [showTimeslotsPage, setShowTimeslotsPage] = useState(false)
    // const [showAddTimeslot, setShowAddTimeslot] = useState(true)
    

    // const handleShowTimesotsPage = (course_id) => {
    //     getTimeslots(course_id)
    //     setCurrCourse(course_id)
    //     setShowCoursesPage(!showCoursesPage)
    //     setShowTimeslotsPage(!showTimeslotsPage)
    // }


    // const handleDate = (day, month) => {
    //     setCurrDay(day);
    //     setCurrMonth(month);
    //     getTimeslots(currCourse)
    // }

    // const getTimeslots = (course_id) => {
    //     setShowCoursesPage(false);
    //     setShowTimeslotsPage(true);
    //     setShowAddTimeslot(false);

    //     fetch(`http://0.0.0.0:4500/next/${course_id}/${currMonth}/${currDay}/timeslots/`, {
    //         "methods" : "GET",
    //         headers: {
    //             Authentication: 'Bearer Token',
    //             "Content-Type": "applications/json"
    //         }
    //         })
    //         .then(res => res.json())
    //         .then(res => setTimeslots(res.timeslots))
    //         .catch(err => console.log(err))
    // } 

    // const addSlot = (time) => {
    //     let slot = {
    //         "start_time": time.start_time,
    //         "end_time": time.end_time,
    //         "day": currDay,
    //         "month": currMonth
    //     }

    //     console.log(slot)
    //     fetch(`http://0.0.0.0:4500/next/${currCourse}/add/`,
    //         {'method':'POST',
    //         headers : {
    //         Authentication: 'Bearer Token',
    //         'Content-Type':'application/json'
    //         },
    //         body:JSON.stringify(slot)
    //         })
    //     .then(response => response.json())
    //     .then(response => setSlot(response.timeslot))
    //     .catch(error => console.log(error))
    // }
    

    return(
        <div className='mainpage'>

             {/* {showCoursesPage && <CoursesPage user_id={user.id} getTimeslots={getTimeslots}></CoursesPage>}
             {showTimeslotsPage && <TimeslotsPage timeslots={timeslots} handleDate={handleDate}></TimeslotsPage>}
             {showAddTimeslot &&  <AddTimeslot addSlot={addSlot} slot={slot}></AddTimeslot>} */}

             <TopSideBars></TopSideBars>
             <CoursesPage></CoursesPage>
            
        </div>
    )
}


export default MainPage