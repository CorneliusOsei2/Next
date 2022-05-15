import { useState } from "react"
import "./coursespage.css"

const CoursesPage = ({getTimeslots, user_id}) => {

    // const [courses, setCourses] = useState([])
    
    // const coursesHandler = (e) => {
    //     getCourses()
    // }

    // const getCourses = () => {
    //     fetch(`http://0.0.0.0:4500/next/dev/${user_id}/courses/`, {
    //       "methods" : "GET",
    //       headers: {
    //           "Content-Type": "applications/json"
    //       }
    //       })
    //       .then(res => res.json())
    //       .then(res => setCourses(res.courses_as_student))
    //       .then(res => console.log(res))
    //       .catch(err => console.log(err))
    //   }
    
    const handleCourseClick = (e) => {
        getTimeslots(e.target.id)
    }

    const courses = [
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"}
    ]

    return(
        <div  className="coursespage">

            {/* <button onClick={coursesHandler}>Click</button> */}

            <div >
                    <div className="row container">

                        {courses.map(course => {
                        return (
                            <div key={course.id} className="col-md-4">
                                <div className="course" id={course.id} code={course.code}>
                                    <div className="course-name">{course.name}</div>
                                    <hr />
                                    <div className="">
                                        <p>Next office hours at: </p>
                                        <button id={course.id} onClick={handleCourseClick} className="btn btn-outline-primary">Timeslots</button>
                                    </div>
                                </div>
                            </div>
                                
                    )}
                        )}
                    </div>
                 
                  
                </div>
        </div>
    )
    

}

export default CoursesPage;