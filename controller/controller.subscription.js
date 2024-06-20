const express = require('express')
const dotenv = require("dotenv")
dotenv.config()
const { useAsync, utils, errorHandle, } = require('./../core');
const MindCastUser = require('../models/model.user')
const MindCastResource = require('../models/model.resources');
const MindCastSubscription = require('../models/model.subscription');





exports.subscription = useAsync(async (req, res) => {

    try{

        const subscription = await MindCastSubscription.create(req.body)
        return res.json(utils.JParser('Subscription created successfully', !!subscription, subscription));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})

exports.singleSubscription = useAsync(async (req, res) => {

    try {
        const resources = await MindCastSubscription.findOne({ _id: req.params.id });
        return res.json(utils.JParser('Subscription fetch successfully', !!resources, resources));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.allSubscription = useAsync(async (req, res) => {

    try {
        const resources = await MindCastSubscription.find();
        return res.json(utils.JParser('Subscriptions fetch successfully', !!resources, resources));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.userSubscription= useAsync(async (req, res) => {

    try {
        const resources = await MindCastResource.find({ userID: req.params.id });
        return res.json(utils.JParser('User subscription fetch successfully', !!resources, resources));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})


exports.deleteSubscription= useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastSubscription.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('Subscription deleted successfully', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

});
