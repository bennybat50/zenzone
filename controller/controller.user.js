const express = require('express')
const router = express.Router()
const bcrypt = require('bcryptjs')
let multer = require('multer')
let fs = require('fs')
let path = require('path');
const address = require('address');
const CryptoJS = require("crypto-js")
const axios = require('axios')
const nodemailer = require('nodemailer');
const jwt = require("jsonwebtoken")
const dotenv = require("dotenv")
dotenv.config()
const request = require('request');
const { useAsync, utils, errorHandle, } = require('./../core');
const MindCastUser = require('../models/model.user')
const MindCastAudit = require('../models/model.audit')
const MindCastInterest = require('../models/model.interest');
const MindCastUserInterest = require('../models/model.userInterest');
const MindCastResource = require('../models/model.resources')
const MindCastRecommend= require('../models/model.recommend');
const MindCastBookmark = require('../models/model.bookmark');
const MoodTracker = require('../models/model.moodTracker');
const { log } = require('console')



// router.get('/all', paginatedResults(MindCastUser), (req, res) => {
//     res.json(res.paginatedResults)
// })

// function paginatedResults(model) {
//     return async (req, res, next) => {
//         const page = parseInt(req.query.page)
//         const limit = parseInt(req.query.limit)

//         const startIndex = (page - 1) * limit
//         const endIndex = page * limit

//         const action = {}

//         if (endIndex < await model.countDocuments().exec()) {
//             action.next = {
//                 page: page + 1,
//                 limit: limit
//             }
//         }

//         if (startIndex > 0) {
//             action.previous = {
//                 page: page - 1,
//                 limit: limit
//             }
//         }
//         try {
//             const results = await model.find().sort({ _id: -1 }).limit(limit).skip(startIndex).exec()
//             let count = await MindCastUser.count()
//             res.paginatedResults = { action, results, TotalResult: count, Totalpages: Math.ceil(count / limit) }
//             next()
//         } catch (e) {
//             res.status(500).json({ message: e.message })
//         }
//     }
// }

//setup

exports.userUpdateMood = useAsync(async (req, res) => {

    try {
         const id = req.userId;
        
        const users = await MindCastUser.find();
        users.forEach((user)=>{

            if (user.mood !=null ) {
                const d = new Date();
                MoodTracker.create({userID:user._id, mood:user.mood, date:d, day:d.getDate(), month:d.getMonth()})
                console.log("Mood updated");
            }
        })
        
        
        return res.json(utils.JParser('Mood Update Successfully',true));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.sendMoodCheck = useAsync(async (req, res) => {

    try {
        let sendData={
            "to":"/topics/MINDCAST-ALERT",
             "priority": "high",
             "content-available":true,
            "notification": {
                "title": "Mood Check",
                "body": "Consistency is key to better mental health. Don't forget to track your mood today.",
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                "priority": "high",
                "content_available": true,
                 "sound": "default"
            },
            "data": {
                "routeId": 6,
                "page": "check_mood"
            }
        }
        

        const headers = {
            'Content-Type': 'application/json',
            'Authorization': `key=${process.env.FIREBASE_NOTIFICATION_KEY}`
          }
          
          
        
        await axios.post('https://fcm.googleapis.com/fcm/send', sendData,{  headers: headers}).then((data)=>{

            return res.json(utils.JParser('Notification Sent Successfully'));
        })

        .catch((error) => {
           console.log(error);
          })

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})




exports.userSettings = useAsync(async (req, res) => {

    try {
        // const id = req.userId;
        const id = req.params.id;
        const body = req.body
        await MindCastUser.updateOne({ _id: id }, body).then(async () => {
            
            if (req.body.mood !=null ) {

                const d = new Date();
               await MoodTracker.create({userID:id, mood:req.body.mood, date:d, day:d.getDate(), month:d.getMonth()})
            }
            const user = await MindCastUser.find({ _id: id });
            return res.json(utils.JParser('Account Setup Successfully', !!user, user));

        })

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.userHomeData = useAsync(async (req, res) => {

    try {
        const user = await MindCastUser.findOne({ _id: req.params.id });
        let userInterest=[]
        let userRecommend=[]
        let userBookmarks=[]
        const allHost = await MindCastUser.find({ isHost: true });
        if(user){

            const alluserInterest = await MindCastUserInterest.find({ userID: req.params.id });
            const allInterests = await MindCastInterest.find();
            const resources = await MindCastResource.find();
            const recommendations = await MindCastRecommend.find();
            const bookmarks = await MindCastBookmark.find({ userID: req.params.id });
            const moods = await MoodTracker.find({ userID: req.params.id });
            
            
            

            allInterests.forEach( interest => {
                let interestedResources=[]

                resources.forEach(aRes => {

                    if(interest._id==aRes.interestID){
                        
                        interestedResources.push(aRes)
                    }
                });
                
                let anInterest={interest, interestedResources }
                
                userInterest.push(anInterest)
               

                
            });

            recommendations.forEach(recommend=>{
                userInterest.forEach( data => { 
                    if(data.interest._id==recommend.interestID){
                        data.interestedResources.forEach( resource => { 
                            let body ={"interestID":data.interest._id, "interestName":data.interest.name,resource }
                            userRecommend.push(body)
                         });
                        
                    }
                });
            })

            bookmarks.forEach(mark=> {
                resources.forEach( (resource,index)=>{
                    if(resource._id  == mark.resourceID ){
                        let data={"bookmarkID":mark._id, resource}
                        userBookmarks.push(data)
                    }
                }) 
            });

            let allMoods=[{"name":"Happy", "data":[]},{"name":"Sad", "data":[]},{"name":"Angry", "data":[]}]

            allMoods.forEach(amood => {
                
            let aMoods=[];
            
            for (let i = 0; i < 12; i++) {
                let total=0

                moods.forEach(element => {
                if(i==element.month && element.mood==amood.name){
                    total=total+1
                }
               });
               aMoods.push({"month":i+1,"total": total})
                
            }
            amood.data=aMoods
            
        });
       
            


            let body={user,userInterest,allHost,userRecommend,userBookmarks,allMoods}


            return res.json(utils.JParser('User Data fetch successfully', !!user, body));
        }
        
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.hostPorfile = useAsync(async (req, res) => {

    try {
        const user = await MindCastUser.findOne({ _id: req.params.id });
        let hostedResources=[]
        if(user){

            const allInterests = await MindCastInterest.find();
            const resources = await MindCastResource.find({ userID: req.params.id });
         
            
            allInterests.forEach( interest => {
                let interestedResources=[]
                        resources.forEach(aRes => {
                            if(interest._id==aRes.interestID){
                                interestedResources.push(aRes)
                            }
                        });

                        let anInterest={interest, interestedResources }
                        
                        hostedResources.push(anInterest)
               
               
                
            });



            let body={user,hostedResources}


            return res.json(utils.JParser('User Data fetch successfully', !!user, body));
        }
        
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.singleUser = useAsync(async (req, res) => {

    try {
        const user = await MindCastUser.findOne({ _id: req.params.id });
        return res.json(utils.JParser('User fetch successfully', !!user, user));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.deleteUser = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastUser.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('User deleted successfully', true, []));

      
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

});

//Audit
exports.audit = useAsync(async (req, res) => {

    try{

        const audit = await MindCastAudit.create(req.body)
        return res.json(utils.JParser('Audit created successfully', !!audit, audit));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})

exports.singleAudit = useAsync(async (req, res) => {

    try {
        const user = await MindCastAudit.findOne({ userID: req.params.id });
        return res.json(utils.JParser('User audit fetch successfully', !!user, user));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.deleteAudit = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastAudit.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('Audit deleted successfully', true, []));

        res.status(200).json("");
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

});

exports.allUser = useAsync(async (req, res) => {

    try {

        const user = await MindCastUser.find()

        res.json(utils.JParser("All businesses", !!user, user));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.changePassword = useAsync(async (req, res) => {

    const user = await MindCastUser.findOne({ _id: req.body.id });

    try {
        if (!req.body.id) return res.status(400).json({ msg: 'provide the id ?', status: 400 })

        if (!user) {
            return res.json(utils.JParser('No User is registered with this id', false, []));
        }

        const originalPassword = await bcrypt.compare(req.body.password, user.password);
        const newp = await bcrypt.compare(req.body.newPassword, user.password);


        if (!originalPassword) {
            return res.json(utils.JParser('wrong password', false, []));
        } else {
            if (newp) {
                return res.json(utils.JParser('You cant change your password to your previous password, use another password and try again', true, []));
            }
            const NewPassword = await bcrypt.hash(req.body.newPassword, 13)
            await MindCastUser.updateOne({ _id: req.body.id }, { password: NewPassword }).then(async () => {
                const New = await MindCastUser.findOne({ _id: req.body.id });
                return res.json(utils.JParser('Password changed Successfully ', !!New, New));

            }).catch((err) => {
                res.send(err)
            })

        }

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})


// router.get("/:id", verify, async (req, res) => {

//     let user = await MindCastUser.find({ _id: req.params.id })

//     if (user) {
//         res.status(200).json(user);
//     } else {
//         res.status(400).json("user not found");
//     }

// })

// router.post("/inactive/:id", async (req, res) => {

//     if (!req.params.id) return res.status(402).json({ msg: 'provide the id ?' })

//     await MindCastUser.updateOne({ _id: req.params.id }, { $set: { active: false } }).then(() => {
//         res.status(200).json({ msg: 'User turned inactive successfully ', status: 200 });
//     })

// })


// router.put('/edit', verify, async (req, res) => {
//     req.body.user_updated_at = Date.now()
//     let body = JSON.parse(JSON.stringify(req.body));
//     let { id } = body;

//     try {
//         if (!req.body.id) return res.status(400).json({ msg: 'provide the id ?', status: 400 })

//         await MindCastUser.updateOne({ _id: id }, body).then(async () => {
//             let user = await MindCastUser.findOne({ _id: id })
//             return res.status(200).json({
//                 msg: 'Account Setup Successfully ',
//                 user: user,
//                 status: 200
//             })
//         }).catch((err) => {
//             res.send(err)
//         })

//     } catch (error) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }

// })




// router.post('/reset_password', async (req, res) => {

//     const user = await MindCastUser.findOne({ email: req.body.email });

//     try {
//         if (!req.body.email) return res.status(400).json({ msg: 'provide the email ?', status: 400 })

//         if (!user) {
//             res.status(400).json({ msg: "No User is registered with this email", status: 400 });
//         }

//         const originalPassword = await bcrypt.compare(req.body.newPassword, user.password);

//         if (originalPassword) {
//             res.status(400).json({ msg: "You cant change your password to your previous password, use another password and try again", status: 400 });
//         }

//         const NewPassword = await bcrypt.hash(req.body.newPassword, 13)
//         await MindCastUser.updateOne({ email: req.body.email }, { $set: { password: NewPassword } })
//         res.status(200).json({
//             msg: 'Password changed Successfully ',
//             password: NewPassword,
//             status: 200
//         })

//     } catch (error) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }

// })


// //PIN
// router.post('/create_pin', verify, async (req, res) => {

//     console.log(req.body)

//     let user = await MindCastUser.findOne({ _id: req.body.id })

//     if (!req.body.pin) return res.status(402).json({ msg: 'provide the Pin ?' })


//     if (user) {

//         req.body.pin = CryptoJS.AES.encrypt(req.body.pin, "mongoro").toString()

//         await MindCastUser.updateOne({ _id: req.body.id }, { pin: req.body.pin }).then(async () => {
//             return res.status(200).json({
//                 msg: 'Pin created Successfully ',
//                 user: user,
//                 status: 200
//             })
//         })
//     } else {
//         res.status(400).json({ msg: "No User is registered with this id!", status: 401 });
//     }



// })

// router.post("/verify_pin", verify, async (req, res) => {

//     const user = await MindCastUser.findOne({ _id: req.body.id });
//     const bytes = CryptoJS.AES.decrypt(user.pin, process.env.SECRET_KEY);
//     const originalPin = bytes.toString(CryptoJS.enc.Utf8);

//     try {
//         if (!req.body.id) return res.status(402).json({ msg: 'provide the id ?', status: 402 })

//         if (originalPin !== req.body.pin) {
//             res.status(401).json({ msg: "wrong pin !", status: 401 });
//         } else {
//             return res.status(200).json({
//                 msg: 'Correct ',
//                 status: 200
//             })
//         }
//     } catch (err) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }
// })

// router.post("/pin_mailer", verify, async (req, res) => {

//     const user = await MindCastUser.findOne({ _id: req.body.id });
//     const bytes = CryptoJS.AES.decrypt(user.pin, process.env.SECRET_KEY);
//     const originalPin = bytes.toString(CryptoJS.enc.Utf8);
//     const code = Math.floor(100000 + Math.random() * 900000)

//     try {
//         if (!req.body.id) return res.status(400).json({ msg: 'provide the id ?', status: 400 })

//         if (req.body.email !== user.email) {
//             return res.status(400).json({ msg: "wrong email", status: 400 });
//         }

//         if (originalPin !== req.body.pin) {
//             res.status(400).json({ msg: "wrong pin !", status: 400 });
//         } else {


//             const url = "https://api.sendchamp.com/api/v1/sms/send"
//             const header = {
//                 headers: {
//                     Authorization: `Bearer ${process.env.SENDCHAMP}`
//                 }
//             }

//             axios.post(url, {
//                 "to": req.body.phone,
//                 "route": "dnd",
//                 "message": "Your verification code is " + code,
//                 "sender_name": "MONGORO-PIN"
//             }, header).then(function (response) {
//                 console.log(JSON.stringify(response.data));
//             })

//             let transporter = nodemailer.createTransport({
//                 service: "hotmail",
//                 auth: {
//                     user: 'support@mongoro.com',
//                     pass: 'cmcxsbpkqvkgpwmk'
//                 }
//             });

//             let mailOptions = {
//                 from: 'support@mongoro.com',
//                 to: req.body.email,
//                 subject: 'Verification code',
//                 html: `<!DOCTYPE html>
//                 <html lang="en">
//                 <head>
//                     <meta charset="UTF-8">
//                     <meta http-equiv="X-UA-Compatible" content="IE=edge">
//                     <meta name="viewport" content="width=device-width, initial-scale=1.0">
//                     <title>Mongoro</title>
//                     <script src="https://kit.fontawesome.com/13437b109b.js" crossorigin="anonymous"></script>
//                     <link rel="preconnect" href="https://fonts.googleapis.com">
//                     <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
//                     <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@200;300;400;500;600;700;800&display=swap" rel="stylesheet">
//                 </head>
//                 <body>
//                     <div class="wrapper" style='width:100%; table-layout: fixed; background: #fff; padding-bottom:60px; font-family: "Plus Jakarta Sans", sans-serif;'>
//                         <table class="main" width="100%">
                            
//                             <tr>
//                                 <td>
//                                     <table width=100% class=sub-main>
//                                         <tr>
//                                             <td>
//                                                 <a>
//                                                     <div style='padding: 1rem; background: #FFF7E6;'>
//                                                         <img 
//                                                             style='width: 7rem; display: block; margin: 0 auto'
//                                                             src='http://res.cloudinary.com/dszrk3lcz/image/upload/v1681388703/dqfex6vpnnncytqrtntx.png' 
//                                                             alt=''
//                                                         />
//                                                     </div>
                                                    
//                                                 </a>
//                                             </td>
//                                         </tr>
//                                         <tr>
//                                             <td>
//                                                 <table width=100%>
//                                                     <tr>
//                                                         <td>
//                                                             <p style='margin:2rem 0; font-weight: 600; color: #292929; line-height: 1.5rem;'>Dear ${user.surname + " " + user.first_name}
//                                                                 <p style='margin:2rem 0; font-size:14px; color: #292929; line-height: 1.5rem;'>
//                                                                     <span>  To delete your account, please verify is your account by entering the code below .</span>
//                                                                 </p>
//                                                                 <br>
//                                                                 <p style='margin:0rem 0; color: #292929; line-height: 1.5rem; font-size: 35px; text-align: left;'>
//                                                                     <span><b>${code}</b></span>
//                                                                 </p>
                                                                
//                                                                 <p style='margin:2rem 0; color: #292929; line-height: 1.5rem;'>
//                                                                     <span>Regards,</span>
//                                                                 </p>
//                                                                 <p style='margin:2rem 0; color: #292929; line-height: 1.5rem;'>
//                                                                     <span><b>Mongoro Team</b></span>
//                                                                 </p>
//                                                                 <hr 
//                                                                     style='border: none; border-bottom: 0.6px solid #FFF7E6'
//                                                                 />
                                                            
//                                                                 <p style='color: #666666; text-align: center; font-size: 14px; margin: 2rem 0 0 0'>www.mongoro.com</p>
//                                                                 <p style='color: #666666; text-align: center; font-size: 14px;'>support@mongoro.com</p>
//                                                                 <p style='color: #666666; text-align: center; font-size: 14px;'>21 Blantyre Crescent, Wuse 2. Abuja</p>
//                                                                 <p style='color: #666666; text-align: center; font-size: 14px; margin: 2rem 0 0 0'> Having trouble viewing this email? Click here to view in your browser.</p>
//                                                         </td>
//                                                     </tr>
//                                                 </table>
//                                             </td>
//                                         </tr>
//                                     </table>
//                                 </td>
//                             </tr>
//                         </table>
//                     </div>
//                 </body>
//                 </html>`,
//             };

//             transporter.sendMail(mailOptions, function (error, info) {
//                 if (error) {
//                     console.log(error);
//                 } else {
//                     console.log('Email sent: ' + info.response);
//                 }
//             });

//             return res.status(200).json({
//                 msg: 'Complete the 2FA verification with the code sent to your mail ',
//                 code: code,
//                 status: 200
//             })
//         }
//     } catch (err) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }
// })

// router.put('/edit_pin', verify, async (req, res) => {

//     const user = await MindCastUser.findOne({ _id: req.body.id });
//     const bytes = CryptoJS.AES.decrypt(user.pin, process.env.SECRET_KEY);
//     const originalPin = bytes.toString(CryptoJS.enc.Utf8);

//     console.log(originalPin)
//     try {
//         if (!req.body.id) return res.status(402).json({ msg: 'provide the id ?', status: 402 })

//         if (originalPin !== req.body.pin) {
//             res.status(401).json({ msg: "wrong pin !", status: 401 });
//         } else {
//             const newPin = CryptoJS.AES.encrypt(req.body.new_pin, "mongoro").toString()
//             await MindCastUser.updateOne({ _id: req.body.id }, { pin: newPin }).then(async () => {
//                 const Newuser = await MindCastUser.findOne({ _id: req.body.id });
//                 return res.status(200).json({
//                     msg: 'Account Setup Successfully ',
//                     user: Newuser,
//                     status: 200
//                 })
//             }).catch((err) => {
//                 res.send(err)
//             })
//         }

//     } catch (error) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }

// })


// router.put('/image', async (req, res) => {

//     try {
//         if (!req.body.id) return res.status(402).json({ msg: 'provide the id ?' })

//         await MindCastUser.updateOne({ _id: req.body.id }, { $set: { image: req.body.image } }).then(async () => {
//             let user = await MindCastUser.findOne({ _id: req.body.id })
//             return res.status(200).json({

//                 msg: 'Image Setup Successfully ',
//                 image: user.image,
//                 status: 200
//             })
//         }).catch((err) => {
//             res.send(err)
//         })

//     } catch (error) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }

// })

// //unBlock
// router.put('/unblock', verify, async (req, res) => {
//     let body = JSON.parse(JSON.stringify(req.body));
//     let { id } = body;
//     try {
//         if (!req.body.id) return res.status(402).json({ msg: 'provide the id ?', status: 402 })

//         await MindCastUser.updateOne({ _id: id }, { $set: { blocked: false } }).then(async () => {
//             return res.status(200).json({
//                 msg: 'unBlocked Successful ',
//                 status: 200
//             })
//         }).catch((err) => {
//             res.send(err)
//         })

//     } catch (error) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }

// })

// //Block
// router.put('/block', verify, async (req, res) => {
//     let body = JSON.parse(JSON.stringify(req.body));
//     let { id } = body;
//     try {
//         if (!req.body.id) return res.status(402).json({ msg: 'provide the id ?', status: 402 })

//         await MindCastUser.updateOne({ _id: id }, { $set: { blocked: true } }).then(async () => {
//             return res.status(200).json({
//                 msg: 'Blocked Successful ',
//                 status: 200
//             })
//         }).catch((err) => {
//             res.send(err)
//         })

//     } catch (error) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }

// })

// ////TIER THREE
// router.put('/tier_three', verify, async (req, res) => {

//     try {
//         if (!req.body.id) return res.status(400).json({ msg: 'provide the id ?', status: 400 })

//         await MindCastUser.updateOne({ _id: req.body.id }, { $set: { tiers: "three", indemnity: true } }).then(async () => {
//             return res.status(200).json({
//                 msg: 'Tiers upgraded Successful ',
//                 status: 200
//             })

//         }).catch((err) => {
//             res.send(err)
//         })

//     } catch (error) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }

// })

// router.get('/state', async (req, res) => {
//     console.log(state)
// })


// router.post('/verify_tag', async (req, res) => {

//     const user = await MindCastUser.findOne({ wallet_ID: req.body.usertag });

//     if (user) {
//         res.status(400).json({ msg: "Unavailable", status: 400 });
//     } else {
//         res.status(200).json({ msg: " Available", status: 200 });
//     }

// })

// router.post('/verify_email', async (req, res) => {

//     try {
//         const user = await MindCastUser.findOne({ email: req.body.email });

//         if (user) {
//             res.status(400).json({ msg: false, status: 400 });
//         } else {
//             res.status(200).json({ msg: true, status: 200 });
//         }
//     } catch (err) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry !',
//             status: 500
//         })
//     }
// })


// router.get('/withtag/:id', verify, async (req, res) => {

//     try {
//         const user = await MindCastUser.findOne({ wallet_ID: req.params.id });

//         if (user) {
//             res.status(200).json({ msg: "User fetch successfully", user, status: 200 });
//         } else {
//             res.status(400).json({ msg: "User not found", status: 400 });
//         }
//     } catch (err) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry !',
//             status: 500
//         })
//     }

// })


//////AUDIT
// router.post('/audit', async (req, res) => {
//     try {
//         if (!req.body.userId) return res.status(400).json({ msg: 'provide the id', status: 400 })

//         const user = await MindCastUser.findOne({ _id: req.body.userId });
//         req.body.name = user.surname + " " + user.first_name
//         req.body.email = user.email
//         req.body.image = user.image
//         req.body.ip = address.ip();

//         let activity = new AuditModel(req.body)
//         activity.save().then(() => {
//             return res.status(200).json({
//                 msg: 'Details added Successful ',
//                 status: 200
//             })
//         })
//     } catch (error) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }
// })

// router.get("/audit/all", async (req, res) => {
//     try {
//         const audit = await AuditModel.find();
//         res.status(200).json(audit.reverse());
//     } catch (err) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry !',
//             status: 500
//         })
//     }
// })

// router.get('/audit/:id', async (req, res) => {
//     try {
//         if (!req.params.id) return res.status(400).json({ msg: 'provide the id ', status: 400 })

//         let audit = await AuditModel.find({ userId: req.params.id })
//         if (audit) {
//             return res.status(200).json({
//                 audit,
//                 status: 200
//             })

//         } else {
//             return res.status(400).json({ msg: 'User not found' })
//         }
//     } catch (error) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }
// })

// router.delete('/audit/delete', async (req, res) => {
//     try {
//         if (!req.body.id) return res.status(400).json({ msg: 'provide the id ', status: 402 })

//         await AuditModel.deleteOne({ _id: req.body.id })
//         return res.status(200).json({
//             msg: "Deleted successfully",
//             status: 200
//         })

//     } catch (error) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }
// })


// router.post('/deletion', verify, async (req, res) => {

//     if ( !req.body.userId ) return res.status(400).json({ msg: 'please check the fields' })

//     try {
//         const code = Math.floor(100000 + Math.random() * 900000)

//         const user = await MindCastUser.findOne({ _id: req.body.userId })
//         if (user) {
//             req.body.phone = user.phone
//             req.body.email = user.email

//             MindCastUser.updateOne({ _id: req.body.userId }, { $set: { note: req.body.note ,  reason: req.body.reason} }).then(async () => {
//                 return res.status(200).json({
//                     msg: 'Successful',
//                     status: 200
//                 })
//             })
//         }
//     } catch (error) {
//         res.status(500).json({
//             msg: 'there is an unknown error sorry ',
//             status: 500
//         })
//     }
// })

// module.exports = router
