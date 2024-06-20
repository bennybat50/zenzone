const express = require('express')
const router = express.Router()
// const MindCastUser = require("../../../models/mongoro/auth/mongoroUser_md")
// const AuditModel = require("../../../models/mongoro/auth/user/audit/audit_md")
const verify = require("../verifyToken")
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
const sha1 = require('sha1');
dotenv.config()
const request = require('request');
// const GlobalModel = require('../../../models/mongoro/admin/super_admin/global/global_md')
const { notify } = require('../core/core.utils');
const { useAsync, utils, errorHandle, } = require('./../core');
const MindCastFavourite = require('../models/model.favourites')
const MindCastUser = require('../models/model.user')
const { EmailNote } = require('../core/core.notify')



exports.userRegister = useAsync(async (req, res) => {

    // req.body.firstName.toLowerCase()
    // req.body.lastName.toLowerCase()
    req.body.username.toLowerCase()

    if (req.body.password) {
        req.body.password = await bcrypt.hash(req.body.password, 13)
    }

    try {
        if (!req.body.email  || !req.body.password || !req.body.username) return res.json(utils.JParser('please check the fields', false, []));

        req.body.token = sha1(req.body.email + new Date())
        req.body.lastLogin = CryptoJS.AES.encrypt(JSON.stringify(new Date()), process.env.SECRET_KEY).toString()

        const validate = await MindCastUser.findOne({ username: req.body.username })
        const validates = await MindCastUser.findOne({ email: req.body.email })
        if (validate) {
            return res.json(utils.JParser('There is another user with this Username', false, []));
        } else if (validates) {
            return res.json(utils.JParser('There is another user with this email', false, []));
        } else {

            let user = await new MindCastUser(req.body)

            await user.save().then(data => {

                const user = {
                    _id: data._id,
                    firstName: data.firstName,
                    lastName: data.lastName,
                    email: data.email,
                    phone: data.phone,
                    username: data.username
                }

                return res.json(utils.JParser('Congratulation you just Created your Mind cast Account', !!user, { user }));

            })
        }
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.userVerified = useAsync(async (req, res) => {
    try {

        await MindCastUser.updateOne({ email: req.body.email }, { $set: { isverified: true } })
        return res.json(utils.JParser('Congratulation your Account is verified', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.userVerify = useAsync(async (req, res) => {
    try {

        let code = Math.floor(100000 + Math.random() * 900000)

        let transporter = nodemailer.createTransport({
            service: "hotmail",
            auth: {
                user: process.env.EMAIL_ADDRESS,
                pass: process.env.APP_PASSWORD
            }
        });

        let mailOptions = {
            from: process.env.EMAIL_ADDRESS,
            to: req.body.email,
            subject: 'Verification code',
            html: `<h1>${code}</h1>`,
        };
        transporter.sendMail(mailOptions, function (error, info) {
            if (error) {
                console.log(error);
            } else {
                console.log('Email sent: ' + info.response);
            }
        });

        return res.json(utils.JParser('Code sent successfully', true, code));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})


exports.userLogin = useAsync(async (req, res) => {

    try {
        res.header("Access-Control-Allow-Origin", "*");
        let UserPassword;

        const ip = address.ip();
        const user = await MindCastUser.findOne({ email: req.body.email })
        let resultt;
        if (user) {
            resultt = user.blocked
            UserPassword = user.password

            //update user if regToken is passed
            if (!!req.body.registration_token) await user.update({ registration_token: req.body.registration_token })

        } else if (resultt === true) {
            return res.json(utils.JParser('Sorry your account is blocked', false, []));
        }

        if (UserPassword) {
            const originalPassword = await bcrypt.compare(req.body.password, UserPassword);

            if (!originalPassword) {
                return res.json(utils.JParser('Wrong password', false, []));
            } else {

                const token = sha1(req.body.email + new Date())
                const IP_Address = { ip_address: ip }
                const lastLogin = CryptoJS.AES.encrypt(JSON.stringify(new Date()), process.env.SECRET_KEY).toString()

                // var callback = function (locate) {
                //     // if (user.notification === true) {
                //         // let transporter = nodemailer.createTransport({
                //         //     service: "hotmail",
                //         //     auth: {
                //         //         user: '',
                //         //         pass: ''
                //         //     }
                //         // });

                //         // let mailOptions = {
                //         //     from: '',
                //         //     to: req.body.email,
                //         //     subject: 'Verification code',
                //         //     html: `<h1>${code}</h1>`,
                //         // };
                //         // transporter.sendMail(mailOptions, function (error, info) {
                //         //     if (error) {
                //         //         console.log(error);
                //         //     } else {
                //         //         console.log('Email sent: ' + info.response);
                //         //     }
                //         // });
                //     // }

                // };

                await MindCastUser.updateOne({ _id: user._id }, { $set: { ip: ip, active: true, token: token, lastLogin: lastLogin } }).then(() => {
                    return res.json(utils.JParser('logged in successfuly', true, { user, token, IP_Address }));
                })
            }
        }
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

//FORGOTPASSWORD 
exports.userPasswordVerify = useAsync(async (req, res) => {

    try {

        let code = Math.floor(100000 + Math.random() * 900000)
        const user = await MindCastUser.findOne({ email: req.body.email });

        if (!user) {
            return res.json(utils.JParser('No User is registered with this email', false, []));
        } else {
            const Name = user.firstName + " " + user.lastName

            EmailNote(req.body.email, Name, 'Here is your 2FA verification code. verify the code .', "Verification Code", code)

            return res.json(utils.JParser('OTP sent successfully', !!user, code));

        }

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})


exports.userEmailVerify = useAsync(async (req, res) => {
    try {

        const user = await MindCastUser.findOne({ email: req.body.email });

        if (user) {
            return res.json(utils.JParser('Email taken already', false, []));
        } else {
            return res.json(utils.JParser('Email available', true, []));
        }

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})


exports.updatePassword = useAsync(async (req, res) => {

    const user = await MindCastUser.findOne({ email: req.body.email });

    try {
        if (!req.body.email) return res.status(400).json({ msg: 'provide the id ?', status: 400 })

        if (!user) {
            return res.json(utils.JParser('No User is registered with this id', true, []));
        }

        const NewPassword = await bcrypt.hash(req.body.password, 13)
        await MindCastUser.updateOne({ email: req.body.email }, { password: NewPassword }).then(async () => {
            // const New = await MindCastUser.findOne({ email: req.body.email });
            return res.json(utils.JParser('Password changed Successfully ', true, []));

        }).catch((err) => {
            res.send(err)
        })

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})