import { useState } from "react"
import "./coursespage.css"

const CoursesPage = ({showTimeslotsPage, user_id}) => {

    const [courses, setCourses] = useState([])
    
    const coursesHandler = (e) => {
        getCourses()
    }

    const getCourses = () => {
        fetch(`http://0.0.0.0:4500/next/${user_id}/courses/`, {
          "methods" : "GET",
          headers: {
              "Content-Type": "applications/json"
          }
          })
          .then(res => res.json())
          .then(res => setCourses(res.courses_as_student))
          .then(res => console.log(res))
          .catch(err => console.log(err))
      }
    
    const handleCourseClick = (e) => {
        showTimeslotsPage(e.target.id)
    }

    return(
        <div>

            <button onClick={coursesHandler}>Click</button>

            <div>

                    <div className="greet-div">
                        Hi, <span className="greet-name">Cornelius</span>
                    </div>

                    <div className="row">

                        {courses.map(course => {
                        return (
                            <div key={course.id} className="col-md-4">
                                <div className="course" id={course.id} code={course.code}>
                                    <div className="top">{course.name}</div>
                                    <hr />
                                    <div className="bottom">
                                        <p>Next office hours at: </p>
                                        <button id={course.id} onClick={handleCourseClick} className="btn btn-outline-danger">Timeslots</button>
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