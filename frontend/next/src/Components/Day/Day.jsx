import "./day.css"

const Day = ({id, number, active}) => {
    
  const day = {
    id, 
    number, 
    active,
    class: active === true ? "active" : "inactive"
  }

    return (
      <button id={id} className={ `day ${day.class}`}>{day.number}</button>
      );
}

export default Day;