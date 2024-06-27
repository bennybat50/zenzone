import axios from 'axios';
import React, { useEffect, useState } from 'react';
import { ThreeDotsVertical, ArrowRightShort } from 'react-bootstrap-icons';
//import facebook from "../assets/image/Logo.png"
//import medium from "../assets/image/Medium.png"
//import google from "../assets/image/Google.png"
//import youtube from "../assets/image/Youtube.png"
//import bing from "../assets/image/Bing.png"
import { BASE_URL, USER_DOMAIN } from '../utils/config';
import { Link } from 'react-router-dom';


function Resource() {

  const [showAll, setShowAll] = useState(false);
  const [resources, setResources] = useState([])
  const [error, setError] = useState(null)

  


  const fetchResources = async () => {
    try {
      const res = await axios.get(`${BASE_URL}${USER_DOMAIN}/resources`);
      console.log('entered:', res.data.data)
      const reversedData = res.data.data.reverse(); // Reverse the data
      setResources(reversedData);
      // console.log("hey")
    } catch (error) {
      setError(error);
    }
  };

  useEffect(() => {

    fetchResources();
  }, []);


  // const resourcesToShow = showAll ? resources : resources.slice(0, 6);

  // const handleSeeMoreClick = () => {
  //   setShowAll(!showAll); 
  // };

  const handleDeleteResource = async (me) => {
    try {
      let auser = { "id": me }
      console.log(auser);
      const response = await axios.post(`${BASE_URL}${USER_DOMAIN}/resources/delete`, auser);
      if (response.status === 200) {
        fetchResources();
        alert("Content Deleted")
        console.log('Data deleted successfully');
      }
    } catch (error) {
      console.error('Error deleting data:', error.message);
    }
  };


  const formatTimestampToDate = (timestamp) => {
    const date = new Date(timestamp);
    return date.toLocaleString();
  };

  return (
    <div className="container card pb-4">
      <div className="table-responsive">
        <table className="table">
          <thead>
            <tr>
              <th scope="col">IMAGE</th>
              <th scope="col">TITLE</th>
              <th scope="col">MOOD TYPE</th>
              <th scope="col">DURATION</th>
              <th scope="col">TIME CREATED</th>
              <th scope="col"></th> 
            </tr>
          </thead>
          <tbody>

            {resources.slice(0, 6).map((resource, index) => {
              return <tr key={resource._id} style={{ display: showAll || index < 6 ? 'table-row' : 'none' }}>
                <th scope="row"><span><img src={resource.image} alt="" className="socialImage" /></span> </th>
                <td>{resource.title}</td>
                <td>
                  {resource.moodType === "happy" ? <label className="badge-pill badge-success mt-3">HAPPY</label> : <></>}
                  {resource.moodType === "sad" ? <label className="badge-pill badge-dark mt-3">SAD        </label> : <></>}
                  {resource.moodType === "angry" ? <label className="badge-pill badge-danger mt-3">ANGRY</label> : <></>}
                </td>
                <td>{resource.duration}</td>
                <td>{formatTimestampToDate(resource.time_created)}</td>
                <td>
                  <li className="nav-item dropdown no-arrow">
                    <a className="nav-link dropdown-toggle" href="#" id="userDropdown"
                      role="button" data-toggle="dropdown" aria-haspopup="true"
                      aria-expanded="false">
                      <i className="bi bi-three-dots-vertical"></i>
                    </a>
                    <div className="dropdown-menu dropdown-menu-left animated--grow-in"
                      aria-labelledby="userDropdown">
                      <a className="dropdown-item" href="#">
                        Approve
                      </a>
                      <a className="dropdown-item" href="#">
                        Send feedback
                      </a>
                      <a className="dropdown-item text-danger" href="#" data-toggle="modal"
                        data-target="" onClick={() => handleDeleteResource(resource._id)}>
                        Delete
                      </a>
                    </div>
                  </li>
                </td>
              </tr>
            })}
          </tbody>
        </table>
      </div>


      <Link to={{ pathname: "/contentPage", state: { resources: resources }}}>
  <div>
    <p className="text-center view-more-social-track text-primary">See all data <ArrowRightShort /></p>
  </div>
</Link>

      
    </div>
  )
}

export default Resource;