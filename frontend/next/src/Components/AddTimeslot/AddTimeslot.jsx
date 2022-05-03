import "./addtimeslot.css"
import { useState } from "react"

const AddTimeslot = ({addSlot, timeslot}) => {
    const [showSlot, setShowSlot] = useState(false)
    const [start, setStart] = useState()
    const [end, setEnd] = useState()


    const handleTimeSubmit = (e) => {
        setShowSlot(true)

        setStart(e.target.from.value)
        setEnd(e.target.to.value)

        // const [start_hrs, start_mins] = e.target.from.value.split(':');
        // const [end_hrs, end_mins] = e.target.to.value.split(':');
        // const startSeconds = (start_hrs) * 60 * 60 + (start_mins) * 60;
        // const endSeconds = (end_hrs) * 60 * 60 + (end_mins) * 60;

        const slot = {
            "start_time": e.target.from.value,
            "end_time": e.target.to.value
        }

        console.log(slot)
        addSlot(slot);
        e.preventDefault();
    }

  
    return (
        <div>

            <form id="timeslot-form" onSubmit={handleTimeSubmit}>
                <input className="form-control time" type="time" id="from" name="start" required></input>
                <input className="form-control time" type="time" id="to" name="end" required></input>

                <button type="submit">Add</button>
            </form>

            {showSlot && <div className="timeslot-view">
                <p>{start}</p>
            </div>}

        </div>
    )
}

export default AddTimeslot