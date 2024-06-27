import React, { useState } from 'react';
import axios from 'axios';
import { BASE_URL, USER_DOMAIN } from '../utils/config';

function EditUserProfileModal({ user }) {
  const [email, setEmail] = useState(user.email);
  const [username, setUsername] = useState(user.username);
  const [mood, setMood] = useState(user.mood);
  const [experience, setExperience] = useState(user.experience);
  const [error, setError] = useState(null);

  const handleFormSubmit = async (event) => {
    event.preventDefault();
    try {
      const updatedUser = { email, username, mood, experience };
      await axios.put(`${BASE_URL}${USER_DOMAIN}/user/setting/${user.id}`, updatedUser);
     
    } catch (error) {
      setError(error);
    }
  };

  return (
    <div className="modal fade" id="editUserProfileModal" tabIndex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div className="modal-dialog" role="document">
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title" id="exampleModalLabel">Edit User Profile</h5>
            <button type="button" className="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div className="modal-body">
            <form onSubmit={handleFormSubmit}>
              <div className="form-group">
                <label htmlFor="email">Email</label>
                <input type="email" className="form-control" id="email" value={email} onChange={(e) => setEmail(e.target.value)} />
              </div>
              <div className="form-group">
                <label htmlFor="username">Username</label>
                <input type="text" className="form-control" id="username" value={username} onChange={(e) => setUsername(e.target.value)} />
              </div>
              <div className="form-group">
                <label htmlFor="mood">Mood</label>
                <input type="text" className="form-control" id="mood" value={mood} onChange={(e) => setMood(e.target.value)} />
              </div>
              <div className="form-group">
                <label htmlFor="experience">Experience</label>
                <input type="text" className="form-control" id="experience" value={experience} onChange={(e) => setExperience(e.target.value)} />
              </div>
              <button type="submit" className="btn btn-primary">Save Changes</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
}

export default EditUserProfileModal;