
import "./course.css"

const Course = () => {

    const courses = ["CS 110", "CS 2110"];

    return(
        
        <div>
            <div className='months-scroll'>
                {courses.map(mnth => {
                  return (
                    <button className="course"> {mnth} </button>
                )}
                )}
            </div>
        </div>
       
    )
}

export default Course