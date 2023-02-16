import React from 'react';
import { Link } from "react-router-dom";

const NavBar = () => {
  return (
    <header className="d-flex justify-content-begin py-3">
      <ul className="nav nav-pills">
        <li className="nav-item"><Link to="/" className="nav-link active">Home</Link></li>
        <li className="nav-item"><Link to="/admin" className="nav-link">Admin</Link></li>
        <li className="nav-item"><Link to="/about" className="nav-link">About</Link></li>
      </ul>
    </header>
  )
}

export default NavBar;