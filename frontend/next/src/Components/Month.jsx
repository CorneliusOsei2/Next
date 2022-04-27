import { useState } from "react";


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
            
            <button onClick={genMonths}>Weeks</button>
            
              <div className='row'>
                {months.map(mnth => {
                  return (
                      
                  <div className='card col-md-3' key={mnth.id}>
                    <div className='card-title'> {mnth.name} </div>
                  </div>
                )}
                )}
            </div>
          </header>
        </div>
      );
}

export default Month;