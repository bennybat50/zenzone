const express = require('express')
const dotenv = require("dotenv")
dotenv.config()
const { useAsync, utils, errorHandle, } = require('../core');
const MindCastUser = require('../models/model.user');
const MindCastCoupon = require('../models/model.cuponCodes');
const nodemailer = require('nodemailer');
const handlebars = require("handlebars")
const fs = require("fs")
const path = require("path")
const stripe = require('stripe')(process.env.SECRET_STP_KEY)



exports.stripePayment = useAsync(async (req, res) => {
    const paymentLink = await stripe.paymentLinks.create({
        line_items: [
          {
            price: 'price_1PRMXYGrAkA0etTmQ3a5bmzm',
            quantity: req.body.totalUsers,
          },
        ],
        after_completion: {
          type: 'redirect',
          
          redirect: {
            url: 'https://www.mindcasts.life/checkout.html',
            
          },
        },
      });
      console.log(paymentLink);
      let data={data:req.body, paymentLink:paymentLink}
      return res.json(utils.JParser('Subscription link', true, data));
      

})

exports.generateCoupon = useAsync(async (req, res) => {

    try {

        let assignedName = req.body.assignedName
        let totalUsers = req.body.totalUsers
        let totalMonths = req.body.totalMonths;
        let email = req.body.email

         let allCodes=``
        for (let i = 0; i < totalUsers; i++) {

            function randomString(length, chars) {

                var result = '';
                for (var i = length; i > 0; --i) result += chars[Math.round(Math.random() * (chars.length - 1))];
                return result;
            }
            let code = randomString(8, '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')

            allCodes+=`<li>Code-${i+1} - <b>${code}</b></li> \n`
            let cupon = { "coupon": code, "email": email, "duration": totalMonths, "price": 0, "assignedName": assignedName, }
            
            await MindCastCoupon.create(cupon)
        }
        const coupons = await MindCastCoupon.find({ email: req.body.email });
        console.log(allCodes);

        let transporter = nodemailer.createTransport({
            host: process.env.EMAIL_HOST,
            port: 465,
            encoding:"ssl",
            secure: true,
            auth: {
                user: process.env.EMAIL_ADDRESS,
                pass: process.env.APP_PASSWORD
            }
        });

        const emailTemplateSource = fs.readFileSync(path.join(__dirname, "../views/mailTemplate-promo.hbs"), "utf8")
        const template = handlebars.compile(emailTemplateSource)
        const htmlToSend = template({ name: req.body.assignedName, coupons:coupons, allCodes:allCodes, totalUsers:totalUsers })

        let mailOptions = {
            from: "Mindcasts App  noreply@mindcasts.life",
            to: req.body.email,
            subject: `${req.body.assignedName} - Subscription Codes`,
            html: htmlToSend,
        };

       

        transporter.sendMail(mailOptions, function (error, info) {
            if (error) {
                console.log(error);
            } else {
                console.log('Email sent: ' + info.response);
            }
        });
        

        return res.json(utils.JParser('Subscription created successfully', !!coupons, coupons));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})


exports.assigncoupon = useAsync(async (req, res) => {

    try {
        const coupon = await MindCastCoupon.findOne({ name: req.body.code });
        if (coupon != null) {

            if (coupon.status == "pending") {
                let totalMonths = coupon.duration;

                var now = new Date();
                var endDate
                if (now.getMonth() == 11) {
                    endDate = new Date(now.getFullYear() + 1, totalMonths, 1);
                } else {
                    endDate = new Date(now.getFullYear(), now.getMonth() + totalMonths, 0);
                }
                let expDate = Date.parse(endDate) / 1000;

                await MindCastCoupon.updateOne({ _id: coupon._id }, { exp_date: expDate, userID: req.body.userID, status: "active" })

                await MindCastUser.updateOne({ _id: req.body.userID }, {"status":"paid","subscription_product":"coupon","subscription_end_date":endDate})

                const updatedCoupon = await MindCastCoupon.find({ _id: coupon._id });

                return res.json(utils.JParser('coupon fetch successfully', !!updatedCoupon, updatedCoupon));
            } else {
                return res.json(utils.JParser('Coupon code already in use ', false));
            }

        } else {
            return res.json(utils.JParser('Coupon not found', false));
        }

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})


exports.checkActivecoupons = useAsync(async (req, res) => {
    try {

        const coupons = await MindCastCoupon.find({ status: "active" });

        coupons.forEach( async data => {

            const firstDate = new Date(data.exp_date)
            const secondDate = new Date().getTime()/1000

            if(firstDate < secondDate){
                await MindCastCoupon.updateOne({ _id: data._id }, { status: "expired" })
                await MindCastUser.updateOne({ _id: data.userID }, {"status":"free","subscription_product":null,})
            }

        


        });

        return res.json(utils.JParser('Coupons Updated', true));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.singlecoupon = useAsync(async (req, res) => {

    try {
        const coupon = await MindCastCoupon.findOne({ _id: req.params.id });
        return res.json(utils.JParser('coupon fetch successfully', !!coupon, coupon));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.allcoupon = useAsync(async (req, res) => {

    try {
        const coupon = await MindCastCoupon.find();
        return res.json(utils.JParser('coupon fetch successfully', !!coupon, coupon));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.usercoupon = useAsync(async (req, res) => {

    try {
        const coupon = await MindCastCoupon.find({ userID: req.params.id });
        return res.json(utils.JParser('User coupon fetch successfully', !!coupon, coupon));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.deletecoupon = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastCoupon.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('coupon deleted successfully', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

});
