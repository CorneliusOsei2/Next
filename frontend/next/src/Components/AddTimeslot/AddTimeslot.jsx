import "./addtimeslot.css"

const AddTimeslot = ({course_id}) => {

    const addSlot = (e) => {
        const slot = {
            "start_time": e.target.start,
            "end_time": e.target.end
        }

        fetch(`localhost:4500/{course_id}/add/`,
            {'method':'POST',
            headers : {
            'Content-Type':'application/json'
            },
            body:JSON.stringify(slot)
            })
        .then(response => response.json())
        .catch(error => console.log(error))
    }
    

    return (
        <div>

            <form className="timeslot-form" onSubmit={addSlot}>
                <input className="form-control" type="time" id="from" name="start" min="09:00" max="18:00" required></input>
                <input className="form-control" type="time" id="to" name="end" min="09:00" max="18:00" required></input>

                <button>Add</button>
            </form>
        </div>
    )
}

export default AddTimeslot