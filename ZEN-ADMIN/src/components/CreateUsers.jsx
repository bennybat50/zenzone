import React, { useEffect, useState } from 'react';
import { BASE_URL, USER_DOMAIN } from '../utils/config';
import { Cloudinary } from "@cloudinary/url-gen";
import axios from 'axios';
import EditUserProfileModal from './Edituser';


function CreateUsers() {
  const [data, setData] = useState([]);
  const [image, setImage] = useState(null)
  const [imageFile, setImageFile] = useState(null)
  const [mood, setMood] = useState(null)
  const [loadingCreation, setLoadingCreation] = useState(false)
  const [email, setEmail] = useState("")
  const [username, setUsername] = useState("")
  const [password, setPassword] = useState("")
  const [error, setError] = useState(null);


  const fetchData = async () => {
    try {
      const res = await axios.get(`${BASE_URL}${USER_DOMAIN}/users`);
      const reversedData = res.data.data.reverse(); // Reverse the data
      setData(reversedData);
      console.log(reversedData)
      //console.log(res.data.data)
    } catch (error) {
      setError(error);
    }
  };
  const sortedUsers = [...data].sort((a, b) => new Date(b.time_created) - new Date(a.time_created));
  useEffect(() => {


    fetchData();
  }, []);




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
  const handleFileSelected = (event) => {
    setImage(URL.createObjectURL(event.target.files[0]))
    setImageFile(event.target.files[0])
  }


  const saveContent = async (event) => {
    event.preventDefault()
    if (imageFile == null) {
      alert("Please select your image file")
    } else {
      setLoadingCreation(true)
      let imageURL = await uploadImage(imageFile)

      if (imageURL != null) {
        let resourceData = {
          "email": email,
          "username": username,
          "image": imageURL,
          "password": password,
          "moodType": mood,
        }
        console.log(resourceData);
        await axios.post(`${BASE_URL}${USER_DOMAIN}/register`, resourceData);
        fetchData();
        setLoadingCreation(false)
        alert("User Created Successfully")
      } else {
        alert("Image or Audio encountered error during upload")
      }
    }


  }


  const handleDelete = async (me) => {
    try {
      let auser = { "id": me }
      console.log(auser);
      const response = await axios.post(`${BASE_URL}${USER_DOMAIN}/users`, auser);
      if (response.status === 200) {
        fetchData();
        alert("User Deleted")
        console.log('Data deleted successfully');
      }
    } catch (error) {
      console.error('Error deleting data:', error.message);
    }
  };

  const handleFormChange = (event) => {

    if (event.target.name === "email") {
      setEmail(event.target.value)
    }

    if (event.target.name === "username") {
      setUsername(event.target.value)
    }

    if (event.target.name === "password") {
      setPassword(event.target.value)
    }

    // if (event.target.name === "userID") {
    //   setUserID(event.target.value)
    // }

    if (event.target.name === "mood") {
      setMood(event.target.value)
    }

  }

  const handleUpdateUser = () => {
    fetchData(); 
  };

  return (
    <div>
      <div className="w-100 container-fluid bg-light pt-4">
        <div className="d-sm-flex justify-content-between mb-4">
          <h1 className="h2 mb-0 dashboard">Users Table</h1>
          <div className="d-flex flex-column flex-sm-row">
            <div style={{ marginTop: 10 + 'px' }} className="create-content order-sm-1">
              <button className="dropdown-item" data-toggle="modal" data-target="#logoutModal">Create Users <span><i class="bi bi-plus"></i></span></button>
            </div>
          </div>

        </div>
      </div>




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
                      {sortedUsers.map(user => (
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
                                <a className="dropdown-item" data-toggle="modal" data-target="#logoutModal">
                                  Edit Profile
                                </a>
                                <a className="dropdown-item" href="#" data-toggle="modal" data-target="#editUserProfileModal">
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




      </div>



{/* create modal */}

      <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="text-dark">Create Users</h4>
              <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">×</span>
              </button>
            </div>
            <div class="container modal-body">
              <form action="" onSubmit={saveContent}>
                <div>
                  <div>
                    <div class="pt-4">
                      <p>UserName</p>
                      <div class="title">
                        <input type="text" name="username" id="username" onChange={handleFormChange} />
                      </div>
                    </div>

                    <div class="pt-4">
                      <p>Email</p>
                      <div class="title">
                        <input type="email" name="email" id="email" onChange={handleFormChange} />
                      </div>
                    </div>

                    <div class="pt-4">
                      <p>Password</p>
                      <div class="title">
                        <input type="password" name="password" id="password" onChange={handleFormChange} />
                      </div>
                    </div>

                    <div class="pt-4 modal-select">
                      <select name="mood" id="mood" class="select-modal" onChange={handleFormChange}>
                        <option value="">Select Mood</option>
                        <option value="happy">HAPPY</option>
                        <option value="sad">SAD</option>
                        <option value="angry">ANGRY</option>
                      </select>
                    </div>

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



                    <div class="modal-create-content">
                      <button type='submit'>{loadingCreation ? <>Uploading Data...</> : <>Create User</>}</button>
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>



      {/* edit user modal */}

 {/* Edit user profile modal */}
 {sortedUsers.map(user => (
        <EditUserProfileModal key={user.id} user={user} onUpdate={handleUpdateUser} />
      ))}
      
    </div>
  )
}

export default CreateUsers