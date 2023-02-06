import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import RateChannel from "../channels/rate_channel";

const Home = () => {
  const [rate, setRate] = useState();

  useEffect(() => {
    RateChannel.connected = () => console.log("conn");
    RateChannel.received = (data) => {
      setRate(JSON.parse(data).rate)
    };
    const url = "/api/v1/rate/index";
    // const token = document.querySelector('meta[name="csrf-token"]').content;

    fetch(url)
      .then((response) => {
        if (response.ok) {
          return response.json();
        }
        throw new Error("Network response was not ok.");
      })
      .then((response) => {
        setRate(response.rate)
      })
      .catch(() => console.log("error"));
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
        <h3 className=" primary-color" >Home page</h3>
        <hr/>
        <p>Dollar rate</p>
        <p>{ rate || "loading..."}</p>
        <button className="btn btn-primary" onClick={()=>{setRate(rate+1)}}>Increment rate</button>
        <hr />
      </div>
    </div>
  );
};

export default Home;