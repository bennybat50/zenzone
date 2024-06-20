/**
 * Slantapp code and properties {www.slantapp.io}
 */
let {MindCastUser} = require('../models/model.user');
const {errorHandle, useAsync} = require('../core');
const CryptoJS = require("crypto-js");

//body safe state
exports.bodyParser = (req, res, next) => {
    if (!Object.keys(req.body).length > 0) throw new errorHandle("the document body is empty", 202);
    else next();
}

//userbodyguard
// exports.userBodyGuard = useAsync(async (req, res, next) => {
//     const xToken =  req.headers['x-token'];
   
//     if ( xToken === 'undefined') throw new errorHandle("Unauthorized Access, Use a valid token and try again", 401);

//     console.log(xToken)
//     //check and decode confirm code validity
//     const isValid = await MindCastUser.find({token: xToken});

//     console.log(isValid)
//     // if (isValid) {
//     //     //****** Decrypt Last Login Date and Time *******//
//     //     const bytes = CryptoJS.AES.decrypt(isValid.lastLogin, process.env.SECRET_KEY);
//     //     let lastLogin = bytes.toString(CryptoJS.enc.Utf8);

//     //     //****** Convert to date from string *******//
//     //     lastLogin = JSON.parse(lastLogin)
//     //     lastLogin = new Date(lastLogin)

//     //     //****** Calculate an hour ago in milliseconds *******//
//     //     const oneHour = 60 * 60 * 1000; /* ms */

//     //     //********** Throw error if token has expired (1hr) **************//
//     //     if (((new Date) - lastLogin) > oneHour) throw new errorHandle("Invalid or expired token, Use a valid token and try again", 401);

//     //     req.userId = isValid._id
//     //     if (isValid.whoIs === 0) next();
//     //     else throw new errorHandle("token is valid but is not authorized for this route, Use a valid token and try again", 401);
// //     } else throw new errorHandle("Invalid token code or token, Use a valid token and try again", 401);
// })
