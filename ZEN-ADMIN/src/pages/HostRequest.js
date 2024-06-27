import React from 'react'
import Sidebar from "../components/Sidebar";
import NavBar from "../components/NavBar";
import AllHostsRequest from '../components/AllHostsRequest';

const HostRequest = () => {
  return (
    <div className="d-flex">
        <Sidebar />

        <div style={{ width: 100 + "%" }}>
            <NavBar />
            <AllHostsRequest className="p-3"/>
        </div>
    </div>)
}

export default HostRequest