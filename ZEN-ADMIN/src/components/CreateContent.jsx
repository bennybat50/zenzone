import axios from 'axios';
import React, { useEffect, useState } from 'react';

import { ThreeDotsVertical, ArrowRightShort } from 'react-bootstrap-icons';
import profileImageOne from "../assets/image/profileImage-one.webp"

import { BASE_URL, USER_DOMAIN } from '../utils/config';
// import singleHost from './SingelHost';
import Resource from './Resource';
import { Cloudinary } from "@cloudinary/url-gen";

 
function CreateContent({ itemId }) {


  const [data, setData] = useState([]);
  const [resources, setResources] = useState([])
  const [interests, setInterests] = useState([]);
  const [hostRequests, setHostRequests] = useState([]);
  const [error, setError] = useState(null);
  const [image, setImage] = useState(null)
  const [imageFile, setImageFile] = useState(null)
  const [audioFile, setAudioFile] = useState(null)
  const [duration, setDuration] = useState(null)
  const [mood, setMood] = useState(null)
  const [loadingCreation, setLoadingCreation] = useState(false)
  const [showAll, setShowAll] = useState(false);


  const [title, setTitle] = useState("")
  const [descp, setDescp] = useState("")
  const [interestID, setInterestID] = useState("")
  const [userID, setUserID] = useState("")


  const uploadImage = async (uploadImg) => {


    const data = new FormData();
    data.append("file", uploadImg);
    data.append("upload_preset", process.env.REACT_APP_CLOUDINARY_UPLOAD_PRESET);
    data.append("cloud_name", process.env.REACT_APP_CLOUDINARY_CLOUD_NAME);
    data.append("folder", "Cloudinary-React");

    try {
      const response = await fetch(
        `https://api.cloudinary.com/v1_1/${process.env.REACT_APP_CLOUDINARY_CLOUD_NAME}/auto/upload`,
        {
          method: "POST",
          body: data,
        }
      );
      const res = await response.json();
      //  console.log(res);

      return res.secure_url

    } catch (error) {

      return null
    }
  };

  useEffect(() => {


    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const res = await axios.get(`${BASE_URL}${USER_DOMAIN}/users`);
      const reversedData = res.data.data.reverse(); // Reverse the data
      setData(reversedData);
      console.log(reversedData)

      const interestsRes = await axios.get(`${BASE_URL}${USER_DOMAIN}/interests`);
      setInterests(interestsRes.data.data);

      const resData = await axios.get(`${BASE_URL}${USER_DOMAIN}/resources`);
      setResources(resData.data.data)

      const hostData = await axios.get(`${BASE_URL}${USER_DOMAIN}/hosts`);
      setHostRequests(hostData.data.data)

      console.log(hostData)
      //console.log(res.data.data)
    } catch (error) {
      setError(error);
    }
  };

  const handleDelete = async (me) => {
    try {
      let auser = { "id": me }
      console.log(auser);
      const response = await axios.post(`${BASE_URL}${USER_DOMAIN}/delete`, auser);
      if (response.status === 200) {
        fetchData();
        alert("User Deleted")
        console.log('Data deleted successfully');
      }
    } catch (error) {
      console.error('Error deleting data:', error.message);
    }
  };



  const sortedUsers = [...data].sort((a, b) => new Date(b.time_created) - new Date(a.time_created));
  // const dataToShow = showAll ? sortedUsers : data.slice(0, 6);

  // const handleSeeMoreClick = () => {
  //   setShowAll(!showAll);
  // };
  const handleFileSelected = (event) => {
    setImage(URL.createObjectURL(event.target.files[0]))
    setImageFile(event.target.files[0])
  }





  const handleAudioSelected = (event) => {

    console.log(event.target.files[0]);
    setAudioFile(event.target.files[0])

    let file = URL.createObjectURL(event.target.files[0]);
    console.log(file);





  }

  const saveContent = async (event) => {
    event.preventDefault()
    if (imageFile == null || audioFile == null) {
      alert("Please select your image and audio file")
    } else {
      setLoadingCreation(true)
      let imageURL = await uploadImage(imageFile)
      let audioURL = await uploadImage(audioFile)

      if (imageURL != null && audioURL != null) {
        let resourceData = {

          "title": title,
          "description": descp,
          "image": imageURL,
          "userID": userID,
          "duration": duration,
          "moodType": mood,
          "interestID": interestID,
          "resourceUrl": audioURL
        }
        console.log(resourceData);
        await axios.post(`${BASE_URL}${USER_DOMAIN}/resources`, resourceData);
        fetchData();
        setLoadingCreation(false)
        alert("Content Uploaded Successfully")
      } else {
        alert("Image or Audio encountered error during upload")
      }
    }


  }

  const handleFormChange = (event) => {

    if (event.target.name === "title") {
      setTitle(event.target.value)
    }

    if (event.target.name === "descp") {
      setDescp(event.target.value)
    }

    if (event.target.name === "interest") {
      setInterestID(event.target.value)
    }

    if (event.target.name === "userID") {
      setUserID(event.target.value)
    }

    if (event.target.name === "mood") {
      setMood(event.target.value)
    }

    if (event.target.name === "duration") {
      setDuration(event.target.value)
    }


  }


  return (
    <>
      <div className="w-100 container-fluid bg-light pt-4">
        <div className="d-sm-flex justify-content-between mb-4">
          <h1 className="h2 mb-0 dashboard">Dashboard</h1>
          <div className="d-flex flex-column flex-sm-row">
            <div style={{ marginTop: 10 + 'px' }} className="create-content order-sm-1">
              <button className="dropdown-item" data-toggle="modal" data-target="#logoutModal">Create Content <span><i class="bi bi-plus"></i></span></button>
            </div>
            <div style={{ marginTop: 10 + 'px', paddingLeft: 20 + "px" }} className="broadcast-btn order-sm-2">
              <button className="dropdown-item" data-toggle="modal" data-target="#Broadcast">Broadcast Messages to All</button>
            </div>
          </div>

        </div>
        <div className="row">
          <div className="col-xl-3 col-md-6 mb-4">
            <div className="card  h-100 py-2">
              <div className="card-body">
                <div className="row no-gutters align-items-center">
                  <div className="col mr-1">
                    <div className="text-xs text-secondary mb-1">
                      Audio files</div>
                    <div className="h5 mb-0 font-weight-bold text-dark">{resources.length}</div>
                  </div>
                  <div className="col-auto">
                    <i className="fas fa-calendar fa-2x text-gray-300"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>


          <div className="col-xl-3 col-md-6 mb-4">
            <div className="card  h-100 py-2">
              <div className="card-body">
                <div className="row no-gutters align-items-center">
                  <div className="col mr-1">
                    <div className="text-xs text-secondary mb-1">
                      Users</div>
                    <div className="h5 mb-0 font-weight-bold text-dark">{sortedUsers.length}</div>
                  </div>
                  <div className="col-auto">
                    <i className="fas fa-calendar fa-2x text-gray-300"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>


          <div className="col-xl-3 col-md-6 mb-4">
            <div className="card h-100 py-2">
              <div className="card-body">
                <div className="row no-gutters align-items-center">
                  <div className="col mr-1">
                    <div className="text-xs text-secondary mb-1">
                      Host request</div>
                    <div className="h5 mb-0 font-weight-bold text-dark">{hostRequests.length}</div>
                  </div>
                  <div className="col-auto">
                    <i className="fas fa-calendar fa-2x text-gray-300"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>


          <div className="col-xl-3 col-md-6 mb-4">
            <div className="card h-100 py-2">
              <div className="card-body">
                <div className="row no-gutters align-items-center">
                  <div className="col mr-1">
                    <div className="text-xs text-secondary mb-1">
                      Avg. time on app</div>
                    <div className="h5 mb-0 font-weight-bold text-dark">00:00</div>
                  </div>
                  <div className="col-auto">
                    <i className="fas fa-calendar fa-2x text-gray-300"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>



        {/* <div className="row">


          <div className="col-xl-8 col-lg-7">
            <div className="card mb-4">

              <div
                className="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 className="m-0 font-weight-bold col-black">User Overview</h6>
                <div className="">
                  <select name="" id="" className="select">
                    <option value="">Today</option>
                  </select>
                </div>
              </div>
              <div className="card-body">
                <div className="chart-area">
                  <canvas id="myAreaChart"></canvas>
                </div>
              </div>
            </div>
          </div>

          <div className="col-xl-4 col-lg-5">
            <div className="card mb-4">
              <div
                className="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 className="m-0 font-weight-bold col-black">Generate coupon</h6>
                <button className="reload-btn">Reload</button>
              </div>
              <div className="card-body">
                <div className="chart-pie pt-4 pb-2">
                  <canvas id="myPieChart"></canvas>
                </div>
                <div className="mt-4 d-flex justify-content-center">
                  <div className="coupon-code text-center ">
                    <p className="pt-3">32u1002311 |<span className="pl-2 text-warning"> Copy</span></p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div> */}

        <div className="row">
          <div className="col-xl-8 col-lg-7">
            <div className="card mb-4">
              <div className="card-header py-3 flex-row">
                <h6 className="m-0 font-weight-bold text-dark">All Users (654)</h6>
              </div>
              <div className="all-users-scroll">
                <div className="p-4 search-users">
                  <input type="text" placeholder="Search Users..." />
                </div>
                <div className="container  pb-4">
                  <div className="table-responsive">
                    <table className="table">
                      <thead>
                        <tr>
                          <th>USER</th>
                          <th>EMAIL</th>
                          <th>MOOD</th>
                          <th>ACTION</th>
                        </tr>
                      </thead>
                      <tbody>
                        {sortedUsers.slice(0, 6).map(user => (
                          <tr key={user.id}>
                            <th scope="row">
                              <span><img src={user.image} alt="" className="userImage" /></span>
                              {user.firstName} <span>{user.lastName}</span>
                            </th>
                            <td className='pt-4'>{user.email}</td>
                            <td>

                              {user.mood === "Happy" ? <label className="badge-pill badge-success mt-3">HAPPY</label> : <></>}
                              {user.mood === "Sad" ? <label className="badge-pill badge-dark mt-3">SAD</label> : <></>}
                              {user.mood === "Angry" ? <label className="badge-pill badge-danger mt-3">ANGRY</label> : <></>}
                            </td>
                            <td>{user.percentage}</td>
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
                                    Make a host
                                  </a>
                                  <a className="dropdown-item" href="#">
                                    Edit Profile
                                  </a>
                                  <a className="dropdown-item" href="#">
                                    Send Message
                                  </a>
                                  <a className="dropdown-item text-danger" href="#" data-toggle="modal"
                                    data-target=""
                                    onClick={() => handleDelete(user._id)}
                                  >
                                    Delete Profile
                                  </a>
                                </div>
                              </li>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                  {/* {data.length > 6 && (
                    <button className="btn btn-primary  w-30" onClick={handleSeeMoreClick}>
                      {showAll ? 'Show Less' : 'See More'}
                    </button>
                  )} */}
                </div>
              </div>

            </div>
          </div>



          <div className="col-xl-4 col-lg-5">
            <div className="card mb-4">
              <div className="card-header py-3 flex-row align-items-center">
                <h6 className="m-0 font-weight-bold text-dark">Become a host requests</h6>
              </div>
              <div className="card-body">

              {hostRequests.map(host => (
                <div className="Profile-image d-flex justify-content-between border-bottom">
                  <div className="d-flex">
                    <img src={host.image}  alt="" className='profileImage' />
                    <div className="Profile-details">
                      <li>{host.firstName} <span>{host.lastName}</span> </li>
                      <li>141 mutual friends</li>
                    </div>
                  </div>
                  <div>
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
                        <a className="dropdown-item text-danger" href="#" data-toggle="modal"
                          data-target="">
                          Decline
                        </a>

                      </div>
                    </li>
                  </div>
                </div>
              ))}
                
                {/* <div className="Profile-image d-flex justify-content-between border-bottom">
                  <div className="d-flex">
                    <img src={profileImageOne} alt="" className='profileImage' />
                    <div className="Profile-details">
                      <li>Laquita Elliott</li>
                      <li>141 mutual friends</li>
                    </div>
                  </div>
                  <div>
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
                        <a className="dropdown-item text-danger" href="#" data-toggle="modal"
                          data-target="">
                          Decline
                        </a>

                      </div>
                    </li>
                  </div>
                </div>
                <div className="Profile-image d-flex justify-content-between border-bottom">
                  <div className="d-flex">
                    <img src={profileImageOne} alt="" className='profileImage' />
                    <div className="Profile-details">
                      <li>Laquita Elliott</li>
                      <li>141 mutual friends</li>
                    </div>
                  </div>
                  <div>
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
                        <a className="dropdown-item text-danger" href="#" data-toggle="modal"
                          data-target="">
                          Decline
                        </a>

                      </div>
                    </li>
                  </div>
                </div>
                <div className="Profile-image d-flex justify-content-between border-bottom">
                  <div className="d-flex">
                    <img src={profileImageOne} alt="" className='profileImage' />
                    <div className="Profile-details">
                      <li>Laquita Elliott</li>
                      <li>141 mutual friends</li>
                    </div>
                  </div>
                  <div>
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
                        <a className="dropdown-item text-danger" href="#" data-toggle="modal"
                          data-target="">
                          Decline
                        </a>

                      </div>
                    </li>
                  </div>
                </div>
                <div className="Profile-image d-flex justify-content-between border-bottom">
                  <div className="d-flex">
                    <img src={profileImageOne} alt="" className='profileImage' />
                    <div className="Profile-details">
                      <li>Laquita Elliott</li>
                      <li>141 mutual friends</li>
                    </div>
                  </div>
                  <div>
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
                        <a className="dropdown-item text-danger" href="#" data-toggle="modal"
                          data-target="">
                          Decline
                        </a>

                      </div>
                    </li>
                  </div>
                </div> */}
              </div>
            </div>
          </div>
        </div>

{/* <singleHost/> */}
        {/* <div className="container card pb-4">
          <div className="table-responsive">
            <table className="table">
              <thead>
                <tr>
                  <th scope="col">SOURCE</th>
                  <th scope="col">PAGE VIEWS</th>
                  <th scope="col">CHANGE</th>
                  <th scope="col">DURATION</th>
                  <th scope="col">BOUNCE</th>
                  <th scope="col">&nbsp;</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <th scope="row"><span><img src={facebook} alt="" className="socialImage" /></span> Facebook</th>
                  <td>12,5564</td>
                  <td>
                    <button className="change-btn-green">+65.31%</button>
                  </td>
                  <td>00:08:10</td>
                  <td>21.32%</td>
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
                          data-target="">
                          Decline
                        </a>
                      </div>
                    </li>
                  </td>
                </tr>
                <tr>
                  <th scope="row"><span><img src={medium} alt="" className="socialImage" /></span>Medium</th>
                  <td>9,567</td>
                  <td>
                    <button className="change-btn-green">+65.31%</button>
                  </td>
                  <td>00:08:10</td>
                  <td>21.32%</td>
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
                          data-target="">
                          Decline
                        </a>
                      </div>
                    </li>
                  </td>
                </tr>
                <tr>
                  <th scope="row"><span><img src={google} alt="" className="socialImage" /></span>Google</th>
                  <td>5,440</td>
                  <td>
                    <button className="change-btn-red">+65.31%</button>
                  </td>
                  <td>00:08:10</td>
                  <td>21.32%</td>
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
                          data-target="">
                          Decline
                        </a>
                      </div>
                    </li>
                  </td>
                </tr>
                <tr>
                  <th scope="row"><span><img src={youtube} alt="" className="socialImage" /></span>Youtube</th>
                  <td>2,767</td>
                  <td>
                    <button className="change-btn-green">+65.31%</button>
                  </td>
                  <td>00:08:10</td>
                  <td>21.32%</td>
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
                          data-target="">
                          Decline
                        </a>
                      </div>
                    </li>
                  </td>
                </tr>
                <tr>
                  <th scope="row"><span><img src={bing} alt="" className="socialImage" /></span>Bing</th>
                  <td>1,443</td>
                  <td>
                    <button className="change-btn-red">+65.31%</button>
                  </td>
                  <td>00:08:10</td>
                  <td>21.32%</td>
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
                          data-target="">
                          Decline
                        </a>
                      </div>
                    </li>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div>
            <p className="text-center view-more-social-track text-primary">See all data <ArrowRightShort /></p>
          </div>
        </div> */}

        <Resource />


      </div>

      <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="text-dark">Create Content</h4>
              <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">×</span>
              </button>
            </div>
            <div class="container modal-body">
              <form action="" onSubmit={saveContent}>
                <div>
                  <div>

                  </div>
                  <div>
                    <p>cover image</p>
                    <div>
                      {image != null ? <img src={image} alt='' className='uploadImg' /> : <></>}
                      <div>
                        <label for="input-file" class="img-cover">
                          <div><span class="text-primary">click to upload</span></div>
                        </label>
                      </div>
                      <input type="file" id="input-file" class="hidden" onChange={handleFileSelected} accept="image/png, image/gif, image/jpeg" />
                    </div>
                    <div class="pt-4">
                      <p>Title</p>
                      <div class="title">
                        <input type="text" name="title" id="title" onChange={handleFormChange} />
                      </div>
                    </div>
                    <div class="pt-4">
                      <p>Description</p>
                      <div class="description">
                        <textarea name="descp" id="" onChange={handleFormChange}></textarea>
                      </div>
                    </div>
                    <div class="pt-4">
                      <p>Duration</p>
                      <div class="title">
                        <input type="text" name="duration" onChange={handleFormChange} />
                      </div>
                    </div>
                    <div class="pt-4 modal-select">
                      <select name="interest" id="" class="select-modal" onChange={handleFormChange}>
                        <option value="">Select Interest</option>
                        {interests.map((data) => {
                          return (<option value={data._id}> {data.name}</option>)
                        })}
                      </select>
                    </div>
                    <div class="pt-4 modal-select">
                      <select name="userID" id="" class="select-modal" onChange={handleFormChange}>
                        <option value="">Select User</option>
                        {sortedUsers.map((user) => {
                          return (<option value={user._id}> {user.email}</option>)
                        })}
                      </select>
                    </div>
                    <div class="pt-4 modal-select">
                      <select name="mood" id="mood" class="select-modal" onChange={handleFormChange}>
                        <option value="">Select Mood</option>
                        <option value="happy">HAPPY</option>
                        <option value="sad">SAD</option>
                        <option value="angry">ANGRY</option>
                      </select>
                    </div>
                    <div class="pt-4">
                      <p>Upload file (audio mp3 format)</p>
                      <div>
                        <div>
                          <label for="input-file1" class="audio-cover"> {audioFile == null ? <><span class="text-primary"> click to upload</span> or drag and drop</> : <>{audioFile.name}</>} </label>
                        </div>
                        <input type="file" id="input-file1" class="hidden" onChange={handleAudioSelected} accept="audio/mp3" />
                      </div>
                    </div>
                    <div class="modal-create-content">
                      <button type='submit'>{loadingCreation ? <>Uploading Data...</> : <>Create Content</>}</button>
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>

      <div class="modal fade" id="Broadcast" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">×</span>
              </button>
            </div>
            <div class="container modal-body">
              <div class="all-users">
                <p>All users <span class="total-users">49</span></p>
              </div>
              <div class="modal-img-row">
                <img src={profileImageOne} alt="" />
                <img src={profileImageOne} alt="" />
                <img src={profileImageOne} alt="" />
                <img src={profileImageOne} alt="" />
                <img src={profileImageOne} alt="" />
                <img src={profileImageOne} alt="" />
              </div>
              <div class="modal-broadcast">
                <p>Send message</p>
                <textarea name="" id=""
                  placeholder="Write description, this will show in users push notifications"></textarea>
                <p>0/1000</p>
                <button class="modal-broadcast-btn">Send</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  )
}

export default CreateContent;


