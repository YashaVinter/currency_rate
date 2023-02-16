import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import NavBar from "./NavBar";

const init_date_time = new Date(new Date().setDate(new Date().getDate() + 1)).toISOString().slice(0,16);

const Admin = () => {
  const navigate = useNavigate();
  const [newRate, setNewRate] = useState(0);
  const [newRateDate, setNewRateDate] = useState("");
  const [dateTime, setDateTime] = useState(init_date_time);
  const [adminRates, setAdminRates] = useState([]);

  const onChange = (event, setFunction) => {
    setFunction(event.target.value);
  };

  const onSubmit = (event) => {
    event.preventDefault();

    const body = {
      new_rate: newRate,
      new_rate_date: new Date(dateTime).getTime()/1000 // timestamp
    };
    const url = "/api/v1/rate/create";
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
    fetch("/api/v1/rate/admin_rates")
      .then((response) => {
        if (response.ok) {
          return response.json();
        }
      })
      .then((rates)=>{
        setAdminRates(rates);
        if (rates.length > 0) {
          // если уже устанавливался, то запишем его
          setNewRate(rates[0].dollar_rate.rate)
          setDateTime(new Date(rates[0].end_timestamp * 1000).toISOString().slice(0,16));
        }
      })
  }, []);

  const adminRatesView = adminRates.map((rate, index)=>(
    <option key={index} value={rate.dollar_rate.rate}></option>
  ));

  const minTimeInTimezone = new Date(new Date().setHours(new Date().getHours() + new Date().getTimezoneOffset()/-60+1)).toISOString().slice(0,16);

  return (
    <div className="m-3">
      <div className="container">
        <NavBar/>
        <h3 className="primary-color" >Admin page</h3>
        <hr/>
        <form onSubmit={onSubmit}>
          <div className="form-group">
            <label htmlFor="newRate" className="form-label">New Rate</label>
            <input
              required
              autoComplete="off"
              type="number"
              min="0"
              step="any"
              name="rate"
              className="form-control"
              list="datalistOptions"
              id="newRate"
              value={newRate}
              onChange={(event) => onChange(event, setNewRate)}
            />
            <datalist id="datalistOptions">
              { adminRates.length > 0 && adminRatesView }
            </datalist>
          </div>
          <div className="form-group">
            <label htmlFor="startDate">New Rate Date</label>
            <input
              id="startDate"
              className="form-control"
              type="datetime-local"
              value={dateTime}
              min={minTimeInTimezone}
              onChange={(event) => onChange(event, setDateTime) }
            />
          </div>
          <button type="submit" className="btn btn-primary custom-button mt-3">
            Create new rate
          </button>
        </form>
      </div>
    </div>
  );
};

export default Admin;