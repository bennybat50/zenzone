import React from 'react'
import Sidebar from "../components/Sidebar";
import NavBar from "../components/NavBar";
import CreateInterest from '../components/CreateInterest';

const InterestPage = () => {
  return (
    <div className="d-flex">
    <Sidebar />

    <div style={{ width: 100 + "%" }}>
        <NavBar />
        <CreateInterest className="p-3"/>
    </div>
</div>
  )
}

export default InterestPage