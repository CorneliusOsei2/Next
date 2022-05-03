
import { useState } from "react"
import "./timeslot.css"
import TimeslotButton from "../TimeslotButton/TimeslotButton"

const Timeslot = ({id, start, end}) => {

    const [state, setState] = useState("join")

    const handleJoinLeaveTimeslot = () => {
        if (state === "join"){
            // Render Queue Page
           setState("leave")
        } else {
            // Exit Queue Page to Timeslot page
            setState("join")
        }
    }
    return (
        <div className="card timeslot">
            <div className="card-title">8:00PM to 9:00PM</div>
            <hr />
            <div className="card-body">
                Office hours

                <TimeslotButton state={state} handleJoinLeaveTimeslot={handleJoinLeaveTimeslot}></TimeslotButton>
            </div>

        </div>
    )
}

export default Timeslot