import { useState } from "react";
import "./month.css"

const Month = () => {
    const [months, setMonths] = useState([]);
  
    const genMonths = () => {
        fetch("http://0.0.0.0:4500/next/months/", {
        "methods" : "GET",
        headers: {
            "Content-Type": "applications/json"
        }
        })
        .then(res => res.json())
        .then(res => setMonths(res.months))
        .catch(err => console.log(err))
    };

    return (
        <div className="App">
          <header className="App-header">
            
            <button onClick={genMonths}>Months Bar</button>
            
              <div className='months-scroll'>
                {months.map(mnth => {
                  return (
                    <button className="month" key={mnth.id}> {mnth.name} </button>
                )}
                )}
            </div>
          </header>
        </div>
      );
}

export default Month;