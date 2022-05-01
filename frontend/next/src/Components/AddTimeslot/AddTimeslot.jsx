
const AddTimeslot = () => {

    const addSlot = (e) => {

    }

    return (
        <div>

            <form className="timeslot-form">
                <input type="time" id="from" name="time" min="09:00" max="18:00" required></input>
                <input type="time" id="to" name="time" min="09:00" max="18:00" required></input>
            </form>
        </div>
    )
}