import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";

const Admin = () => {
  const navigate = useNavigate();
  const [newRate, setNewRate] = useState(0);
  const [newRateDate, setNewRateDate] = useState("");

  const onChange = (event, setFunction) => {
    setFunction(event.target.value);
  };

  const onSubmit = (event) => {
    event.preventDefault();
    const url = "/api/v1/rate/create";

    const body = {
      new_rate: newRate,
      new_rate_date: newRateDate
    };

    const token = document.querySelector('meta[name="csrf-token"]').content;
    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": token,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    })
      .then((response) => {
        if (response.ok) {
          return response.json();
        }
        throw new Error("Network response was not ok.");
      })
      .then((response) => navigate("/"))
      .catch((error) => console.log(error.message));
  };

  useEffect(() => {

  }, []);

  return (
    <div className="m-3">
      <div className="container">
        <header className="d-flex justify-content-begin py-3">
          <ul className="nav nav-pills">
            <li className="nav-item"><Link to="/" className="nav-link active">Home</Link></li>
            <li className="nav-item"><Link to="/admin" className="nav-link">Admin</Link></li>
            <li className="nav-item"><a href="#" className="nav-link">About</a></li>
          </ul>
        </header>
        <h3 className="primary-color" >Admin page</h3>
        <hr/>
        <form onSubmit={onSubmit}>
          <div className="form-group">
            <label htmlFor="newRate">New rate</label>
            <input
              type="text"
              name="rate"
              id="newRate"
              className="form-control"
              required
              onChange={(event) => onChange(event, setNewRate)}
            />
          </div>
          <div className="form-group">
            <label htmlFor="newRateDate">New Rate Date</label>
            <input
              type="text"
              name="rateDate"
              id="newRateDate"
              className="form-control"
              required
              onChange={(event) => onChange(event, setNewRateDate)}
            />
          </div>
          <button type="submit" className="btn btn-primary custom-button mt-3">
            Create new rate
          </button>
        </form>
        <div>
          <label for="exampleDataList" class="form-label">Datalist example</label>
          <input class="form-control" list="datalistOptions" id="exampleDataList"/>
          <datalist id="datalistOptions">
            <option value="100"/>
            <option value="200"/>
          </datalist>
        </div>
      </div>

    </div>
  );
};

export default Admin;