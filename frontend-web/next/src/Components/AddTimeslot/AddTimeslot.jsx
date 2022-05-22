import "./addtimeslot.css"
import { useState } from "react"

const AddTimeslot = ({addSlot, timeslot}) => {
    const [showSlot, setShowSlot] = useState(false)
    const [start, setStart] = useState()
    const [end, setEnd] = useState()
    const [virtual, setVirtual] = useState(true)


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

    const modeHandler = (e) => {
        let targetMode = e.target.id;
        
        if (targetMode === "in-person"){
            setVirtual(false);
        } else{
            setVirtual(true);
        }

        let modeOptions = document.getElementsByName("mode");
        modeOptions.forEach((option) => {
            console.log(option)
            if (option.id !== targetMode){
                option.checked = false;
            }
        })
       

    }
  
    return (
        <div id="addtimeslot-page">

            <form id="timeslot-form" onSubmit={handleTimeSubmit}>
                <label htmlFor="timeslot-title">Title</label>
                <input id=" timeslot-title" className="form-control" type="text" required/>
                <label htmlFor="from">Start Time</label>
                <input className="form-control time" type="time" id="from" name="start" required/>
                <label htmlFor="to">End Time</label>
                <input className="form-control time" type="time" id="to" name="end" required/>
                
                <div className="timeslot-location">
                    <p>Mode</p>
                    <div className="d-flex" required>
                    <input id="in-person" name="mode" type="radio" onClick={modeHandler}></input><label htmlFor="in-person">In-person</label>
                        <label htmlFor="virtual">Virtual</label> <input id="virtual" name="mode" type="radio" onClick={modeHandler}/>
                    </div>

                    {virtual && 
                        <div className="virtual-mode">
                            <label>Provide Link</label>
                            <textarea className="form-control" name="" id="" cols="30" rows="2" required></textarea>
                        </div>
                        
                    }

                   
                </div>

                <div className="">
                    <label>Each week? </label><input type="checkbox"/>
                    <label htmlFor="timeslot-message"></label>
                </div>
                
                <textarea id="timeslot-message" className="form-control" type="text"></textarea>
                <button className="btn btn-primary" type="submit">Add</button>
            </form>

            {showSlot && <div className="timeslot-view">
                <p>{start}</p>
            </div>}

        </div>
    )
}

export default AddTimeslot