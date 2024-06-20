/**
 * Slantapp code and properties {www.slantapp.io}
 */

const {useAsync} = require("./index");
const path = require('path');
const {utils, errorHandle} = require("../core");
const { emailTemple } = require("../services");



exports.EmailNote = async (email, name, body, subject, otp) => {
    try {
        await new emailTemple(email)
            .who(name)
            .body(body)
            .btnText(!!otp ? otp : "")
            .subject(subject).send().then(r => console.log(r));
    } catch (e) {
        console.log("Error sending:", e);
        return e
    }
}
