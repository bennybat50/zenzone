import React from 'react'
import CreateUsers from '../components/CreateUsers'
import NavBar from '../components/NavBar'
import Sidebar from "../components/Sidebar";


const Users = () => {
    return (
        <div className="d-flex">
    <Sidebar />

    <div style={{ width: 100 + "%" }}>
        <NavBar />
        <CreateUsers className="p-3"/>
    </div>
</div>
    )
}

export default Users