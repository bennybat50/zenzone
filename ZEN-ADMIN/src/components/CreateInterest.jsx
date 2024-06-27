import { useState, useEffect } from "react";
import { BASE_URL, USER_DOMAIN } from '../utils/config';
import axios from 'axios';
import { useNavigate } from "react-router-dom";



function CreateInterest() {
    const [interests, setInterests] = useState([]);
    const [postinterests, setPostInterests] = useState([]);
    const [error, setError] = useState(null);
    const [image, setImage] = useState(null)
    const [imageFile, setImageFile] = useState(null)
   const [loadingCreation, setLoadingCreation] = useState(false)

   const navigate = useNavigate('')
    useEffect(() => {


        fetchData();
    }, []);

    const fetchData = async () => {
        try {
            const interestsRes = await axios.get(`${BASE_URL}${USER_DOMAIN}/interests`);
            setInterests(interestsRes.data.data);
            //console.log(res.data.data)
        } catch (error) {
            setError(error);
        }
    };

    const handleDelete = async (interestId) => {
        try {
            // let auser = { "id": me } 
            // console.log(auser);
            const response = await axios.post(`${BASE_URL}${USER_DOMAIN}/interest/delete`, { id: interestId })
            if (response.status === 200) {
                // fetchData();
                alert("User interests deleted")
                console.log('interests deleted successfully');
            }
        } catch (error) {
            console.error('Error deleting data:', error.message);
        }
    };



    const postIntrest = async (event) => {
        event.preventDefault()


        try {
            let resourceData = {
                name: postinterests,
              }

              const res = await axios.post(`${BASE_URL}${USER_DOMAIN}/interest`, resourceData);
              console.log("Post interests response:", res.data);
              setPostInterests(res.data);
              if(res)(
              navigate("/createInterest")
              )
        } catch (error) {
            setError(error)
        }
    
    };



    const handleFormChange = (event) => {

        if (event.target.name === "Interest") {
            setPostInterests(event.target.value)
        }
    }

    return (
        <>


            <div className="w-100 container-fluid bg-light pt-4">
                <div className="d-sm-flex justify-content-between mb-4">
                    <h1 className="h2 mb-0 dashboard">Dashboard</h1>
                    <div className="d-flex flex-column flex-sm-row">
                        <div style={{ marginTop: 10 + 'px' }} className="create-content order-sm-1">
                            <button className="dropdown-item" data-toggle="modal" data-target="#logoutModal">Create Interest <span><i class="bi bi-plus"></i></span></button>
                        </div>
                    </div>
                </div>
            </div>



            <div className="w-100 container-fluid bg-light pt-4">

            <div className=" w-100 ">
                <div className="card mb-4">
                    <div className="card-header py-3 flex-row">
                        <h6 className="m-0 font-weight-bold text-dark">All Interests</h6>
                    </div>
                    <div className="all-users-scroll">
                        <div className="p-4 search-users">
                            <input type="text" placeholder="Search Interests..." />
                        </div>
                        <div className="container  pb-4">
                            <div className="table-responsive">
                                <table className="table">
                                    <thead>
                                        <tr>
                                            <th>Interests</th>
                                            <th>ACTION</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {interests.map((interest) => (
                                              
                                            <tr key={interest.id}>
                                                <th scope="row">
                                                   {interest.name}
                                                </th>
                                                <td>
                                                    <li className="nav-item dropdown no-arrow">
                                                        <a className="nav-link dropdown-toggle" href="#" id="userDropdown"
                                                            role="button" data-toggle="dropdown" aria-haspopup="true"
                                                            aria-expanded="false">
                                                            <i className="bi bi-three-dots-vertical"></i>
                                                        </a>
                                                        <div className="dropdown-menu dropdown-menu-left animated--grow-in"
                                                            aria-labelledby="userDropdown">
                                                            <a className="dropdown-item text-danger" href="#" data-toggle="modal"
                                                                data-target=""
                                                                onClick={() => handleDelete(interest.interest_id)}
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

                        </div>
                    </div>

                </div>
            </div>

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
                            <form action="" onSubmit={postIntrest}>
                                <div>
                                   
                                    <div>
                                        <p>cover image</p>
                                        {/* <div>
                                            {image != null ? <img src={image} alt='' className='uploadImg' /> : <></>}
                                            <div>
                                                <label for="input-file" class="img-cover">
                                                    <div><span class="text-primary">click to upload</span></div>
                                                </label>
                                            </div>
                                            <input type="file" id="input-file" class="hidden" onChange={handleFileSelected} accept="image/png, image/gif, image/jpeg" />
                                        </div> */}

                                        <div class="pt-4">
                                            <p>Interest</p>
                                            <div class="title">
                                                <input type="text" name="Interest" id="Interest" onChange={handleFormChange} />
                                            </div>
                                        </div>

                                        <div class="modal-create-content">
                                            <button type='submit'> Create Content</button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </>
    )
}

export default CreateInterest