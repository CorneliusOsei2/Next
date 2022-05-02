
import "./course.css"

const Course = ({name, code}) => {

    const btnClasses = ["btn-outline-primary", "btn-outline-secondary", "btn-outline-success"];

    const course = {
        name,
        code,
        class: name.slice(name.indexOf(" "))
    }
    const courses = ["CS 2800"]

    return(
        
        <div>
            <div className='courses-pane'>
                
            </div>
        </div>
       
    )
}

export default Course