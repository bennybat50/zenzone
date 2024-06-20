const express = require('express')
const dotenv = require("dotenv")
dotenv.config()
const { useAsync, utils, errorHandle, } = require('../core');
const MindCastApp = require('../models/model.app');
const MindCastAppMessage = require('../models/model.appMessage');
 



exports.app_version_create = useAsync(async (req, res) => {

    try{

        const app = await MindCastApp.create(req.body)
        return res.json(utils.JParser('App Version Created Successfully', !!app, app));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})

exports.singleAppVersion = useAsync(async (req, res) => {

    try {
        const appVersions = await MindCastApp.find({}).sort({_id:-1}).limit(1);
        return res.json(utils.JParser('App Version successfully', !!appVersions, appVersions[0]));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.app_message_create = useAsync(async (req, res) => {

    try{

        const message = await MindCastAppMessage.create(req.body)
        return res.json(utils.JParser('App Message Created Successfully', !!message, message));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})

exports.singleAppMessage = useAsync(async (req, res) => {

    try {
        const appMessage = await MindCastAppMessage.find({}).sort({_id:-1}).limit(1);

        return res.json(utils.JParser('App Message successfully', !!appMessage, appMessage[0]));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.deleteAppVersion = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastApp.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('App version deleted successfully', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

});

exports.deleteAppMessage = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastAppMessage.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('App Message deleted successfully', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

});
