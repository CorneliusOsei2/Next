
import "./course.css"

const Course = ({name, code}) => {

    const btnClasses = ["btn-outline-primary", "btn-outline-secondary", "btn-outline-success"];

    const course = {
        name,
        code,
        class: name[name.indexOf(" ")]
    }
    const courses = ["CS 2800"]

    return(
        
        <div>
            <div className='courses-pane'>
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