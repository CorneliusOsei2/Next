

const Month = ({id, name, getDays}) => {

  const month = {
    id: id,
    name: name
  }

  const daysHandler = (e) => {
    getDays(e.target.id);
  }

  return(
    <button id={id} className="month" onClick={daysHandler}>{month.name}</button>
  )
}

export default Month