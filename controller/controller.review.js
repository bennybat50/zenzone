const express = require('express')
const dotenv = require("dotenv")
dotenv.config()
const { useAsync, utils, errorHandle, } = require('./../core');
const MindCastUser = require('../models/model.user')
const MindCastResource = require('../models/model.resources');
const MindCastReview = require('../models/model.reviews');



exports.review = useAsync(async (req, res) => {

    try{

        const review = await MindCastReview.create(req.body)
        return res.json(utils.JParser('Review created successfully', !!review, review));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})

exports.singleReview = useAsync(async (req, res) => {

    try {
        const review = await MindCastReview.findOne({ _id: req.params.id });
        return res.json(utils.JParser('Review fetch successfully', !!review, review));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.allReview = useAsync(async (req, res) => {

    try {
        const review = await MindCastReview.find();
        return res.json(utils.JParser('Review fetch successfully', !!review, review));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.userReview = useAsync(async (req, res) => {

    try {
        const review = await MindCastReview.find({ userID: req.params.id });
        return res.json(utils.JParser('User Review fetch successfully', !!review, review));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.deleteReview = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastReview.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('Review deleted successfully', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

});
