import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "../components/Home";
import Admin from "../components/Admin";
import About from "../components/About";

export default (
  <Router>
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/admin" element={<Admin />} />
      <Route path="/about" element={<About />} />
    </Routes>
  </Router>
);