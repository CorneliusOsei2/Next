import { useState } from "react"
import "./coursespage.css"
import cornerArc from "../../assets/images/cornerArc.png"
import cornerArcs from "../../assets/images/cornerArcs.png"

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

    const coursesAsStudent = [
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"}
    ]

    const coursesAsInstructor = [
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"},
        {id: 1, code: "CS 1110", name: "Intro to Computing Using Python"}
    ];

    return(
        <div  className="coursespage">

            {/* <button onClick={coursesHandler}>Click</button> */}

            
            
            <div >
                    {coursesAsStudent && 
                        <div className="student-courses-title">
                            <h5>Courses Enrolled In As Student</h5>
                        </div>
                    }

                    <div className="row container courses-container">
                        {coursesAsInstructor.map(course => {
                        return (
                            <div key={course.id} className="col-md-4">
                                <div className="course">
                                    <div className="course-container">
                                        <div className="course-title">
                                            <h3 className="course-code">CS 1110</h3>
                                        </div>
                                        <div>
                                        Heyya, this is Next!
                                        </div>
                                    </div>
                                </div>
                            </div>
                            )}
                        )}
                    </div>

                    {coursesAsStudent && 
                        <div className="student-courses-title mt-3">
                            <h5>Courses Enrolled In As Student</h5>
                        </div>
                    }
                    <div className="row container courses-container">
                        {coursesAsInstructor.map(course => {
                        return (
                            <div key={course.id} className="col-md-4">
                                <div className="course">
                                    <div className="course-container">
                                        <div className="course-title">
                                            <h3 className="course-code">CS 1110</h3>
                                        </div>
                                        <div>
                                        Heyya, this is Next!
                                        </div>
                                    </div>
                                </div>
                            </div>
                            )}
                        )}
                    </div>

                </div>
            
            <div className="corner-arcs d-flex">
            <img  src={cornerArc} alt="" />
            <img src={cornerArcs} alt="" />
            </div>
           
        </div>
    )
    

}

export default CoursesPage;