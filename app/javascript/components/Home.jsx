import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import RateChannel from "../channels/rate_channel";
import NavBar from "./NavBar";

const Home = () => {
  const [rate, setRate] = useState();

  useEffect(() => {
    RateChannel.connected = () => console.log("connection established");
    RateChannel.received = (data) => {
      setRate(JSON.parse(data).rate)
    };
    const url = "/api/v1/rate/index";

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
        <NavBar/>
        <h3 className=" primary-color" >Home page</h3>
        <hr/>
        <p>Dollar rate</p>
        <p>{ rate || "loading..."}</p>
      </div>
    </div>
  );
};

export default Home;