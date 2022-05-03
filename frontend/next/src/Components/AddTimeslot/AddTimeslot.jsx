import "./addtimeslot.css"
import { useState } from "react"

const AddTimeslot = ({addSlot, timeslot}) => {
    const [showSlot, setShowSlot] = useState(false)
    const [start, setStart] = useState()

    const handleTimeSubmit = (e) => {
        setShowSlot(!showSlot)
        setStart( e.target.from.value)

        const [start_hrs, start_mins, start_secs] = start.split(':');
        const [end_hrs, end_mins, end_secs] = start.split(':');
        const startSeconds = (+start_hrs) * 60 * 60 + (+start_mins) * 60 + (+start_secs);
        const endSeconds = (+end_hrs) * 60 * 60 + (+end_mins) * 60 + (+end_secs);

        const slot = {
            "start_time": startSeconds,
            "end_time": endSeconds
        }
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
                <p>Tada</p>
            </div>}

        </div>
    )
}

export default AddTimeslot