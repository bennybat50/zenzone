import React, { useEffect, useState } from 'react';
import { BASE_URL, USER_DOMAIN } from '../utils/config';
import SingleHost from './SingelHost';
import axios from 'axios';



function AllHostsRequest(props) {
    const [hostRequests, setHostRequests] = useState([]);
    const [error, setError] = useState(null);
    useEffect(() => {


        fetchData();
      }, []);
    
      const fetchData = async () => {
        try {
          const hostData = await axios.get(`${BASE_URL}${USER_DOMAIN}/hosts`);
          setHostRequests(hostData.data.data)
          const userIds = hostData.data.data.map(host => host.userID);
          console.log("User IDs:", userIds);
          console.log(hostData) 
          //console.log(res.data.data)
        } catch (error) {
          setError(error);
        }
      };
    return(
        <>
        <div className="row">
          <div className="col-xl-8 col-lg-7">
            <div className="card mb-4">
              <div className="card-header py-3 flex-row">
                <h6 className="m-0 font-weight-bold text-dark">All Users (654)</h6>
              </div>
              <div className="all-users-scroll">
                <div className="container  pb-4">
                <div className="table-responsive">
                {hostRequests.map(hostItem => (
                <div key={hostItem.userID}>
                    <SingleHost user_id={hostItem.userID} />
                </div>
            ))}
                                </div>
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

              {hostRequests && hostRequests.map(hostItem => (
                <div key={hostItem.userId} className="Profile-image d-flex justify-content-between border-bottom">
                  <div className="d-flex">
                    <img src={hostItem.image}  alt="" className='profileImage' />
                    <div className="Profile-details">
                      <li>{hostItem.reason} <span>{hostItem.lastName}</span> </li>
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
                
                
              </div>
            </div>
          </div>
        </div>
        </>
    )
}
export default AllHostsRequest



