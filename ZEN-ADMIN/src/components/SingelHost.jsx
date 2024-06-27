import axios from 'axios';
import React, { useEffect, useState } from 'react'

import { BASE_URL, USER_DOMAIN } from '../utils/config';

export default function SingleHost({props}) {
    const [user, setUser] = useState("");
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            try {
                
                const res = await axios.get(`${BASE_URL}${USER_DOMAIN}/single/${props.user_id}`);
                console.log(res.data)
                setUser(res.data.data);
                console.log(res.data.data)
            } catch (error) { 
                setError(error);
            } 
        };

        fetchData();
    },[]);

    // const singleUserID = data._id;

    return(
        <table>
            <tbody>
            {/* {host && host.map(hostItem => ( */}
                    <tr >
                    <th scope="row">
                    <span><img src={user.image} alt="" className="userImage"/></span>
                    {user.username} <span>{user.lastName}</span>
                  </th>
                  <td className='pt-4'>{user.email}</td>
                  <td>
                    <button className="change-btn-green mt-3">Mood</button>
                  </td>
                  <td>{}</td>
                  <td>{user.percentage}</td>
                    </tr>
                {/* ))} */}
            </tbody>
        </table>
    )
    
}