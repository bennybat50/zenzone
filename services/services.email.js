'use strict';
/**
 * Slantapp code and properties {www.slantapp.io}
 */
const nodemailer = require("nodemailer");
const fs = require('fs');
require('dotenv').config();

class MailTemple {
    // btnUrl = "https://mongoro.com";
    // btnText = "Check classes";
    constructor(to) {
        this.to = to;
    }

    to(to) {
        this.to = to;
        return this;
    }

    who(name) {
        this.name = name;
        return this;
    }

    btnText(text) {
        this.btnText = text;
        return this;
    }

    btnUrl(url) {
        this.btnUrl = url;
        return this;
    }

    subject(sub) {
        this.subject = sub;
        return this;
    }

    body(body) {
        this.body = body;
        return this;
    }

    async send() {
        //compute email sending template here...
        const rd = fs.readFileSync(__dirname + '/template/template.mt');
        const rawTmpl = rd.toString('utf-8');
        const compile = render(rawTmpl, {body: this.body, name: this.name, btnText: this.btnText, btnUrl: this.btnUrl});
        return await transporter(compile, this.to, this.subject);
    }
}

// async..await is not allowed in global scope, must use a wrapper
async function transporter(html, to, sub) {
    // Generate test SMTP service account from ethereal.email
    // Only needed if you don't have a real mail account for testing

    // create reusable transporter object using the default SMTP transport
    let transporter = nodemailer.createTransport(
        {
            // service: process.env.EMAIL_HOST,
            // port: 587,
            // secure: false, // true for 465, false for other ports
            service: 'gmail',
            host: 'smtp.gmail.com',
            auth: {
                user: process.env.EMAIL_ADDRESS, // generated ethereal business
                pass: process.env.APP_PASSWORD, // generated ethereal password
            },
        });
    // send mail with defined transport object
    return transporter.sendMail({
        from: `${sub} <${process.env.EMAIL_ADDRESS}>`, // sender address
        to: to, // list of receivers
        subject: sub, // Subject line
        html: html, // html body
    });
    //console.log("Message sent: %s", info.messageId);
    // Message sent: <b658f8ca-6296-ccf4-8306-87d57a0b4321@example.com>
}

let render = (template, data) => {
    return template.replace(/{{(.*?)}}/g, (match) => {
        let mkd = match.split(/{{|}}/).filter(Boolean)[0];
        let a = data[mkd];
        if (a instanceof Array)
            return a.join('\n');
        return data[mkd];
    })
}
module.exports = MailTemple;