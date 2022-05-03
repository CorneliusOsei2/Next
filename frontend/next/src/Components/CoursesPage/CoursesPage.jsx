
import { useEffect, useState } from "react"
import Course from "../Course/Course"

const CoursesPage = () => {

    const [courses, setCourses] = useState({})
    /** TODO */
    const [user, setUser] = useState({"name": "Cornelius"})

    

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

    useEffect(
        getCourses()
    )
    
    return(
        <div>

                <div>
                    {courses.map(course => {
                        return (
                        <Course name={course.name} code={course}></Course>
                    )}
                    )}
                  
                </div>

        </div>
    )


  
      
}

export default CoursesPage;