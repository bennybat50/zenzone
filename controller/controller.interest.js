const express = require('express')
const dotenv = require("dotenv")
dotenv.config()
const { useAsync, utils, errorHandle, } = require('./../core');
const MindCastUser = require('../models/model.user')
const MindCastInterest = require('../models/model.interest');
const MindCastUserInterest = require('../models/model.userInterest');



exports.interest = useAsync(async (req, res) => {

    try{

        const interest = await MindCastInterest.create(req.body)
        return res.json(utils.JParser('Interest created successfully', !!interest, interest));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})

exports.interestUpdate = useAsync(async (req, res) => {

    try {
        // const id = req.userId;
        const id = req.params.id;
        const body = req.body
        await MindCastInterest.updateOne({ _id: id }, body).then(async () => {
            const interest = await MindCastInterest.find({ _id: id });
            return res.json(utils.JParser('Interest Updated  Successfully', !!interest, interest));
        })

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.createUserInterest = useAsync(async (req, res) => {

    try{

        const interest = await MindCastUserInterest.create(req.body)
        return res.json(utils.JParser('User Interest created successfully', !!interest, interest));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})

exports.singleInterest = useAsync(async (req, res) => {

    try {
        const interest = await MindCastInterest.findOne({ _id: req.params.id });
        return res.json(utils.JParser('Interest fetch successfully', !!interest, interest));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.allInterest = useAsync(async (req, res) => {

    try {
        const interest = await MindCastInterest.find();
        return res.json(utils.JParser('Interest fetch successfully', !!interest, interest));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.userInterest = useAsync(async (req, res) => {

    try {
        const interest = await MindCastUserInterest.find({ user_id: req.params.id });
        return res.json(utils.JParser('User Interest fetch successfully', !!interest, interest));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.interestUser = useAsync(async (req, res) => {

    try {
        const interest = await MindCastUserInterest.find({ interest_id: req.params.id });
        return res.json(utils.JParser('Interest User fetch successfully', !!interest, interest));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.deleteUserInterest = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastUserInterest.deleteOne({ _id: req.body.id }).catch((error)=>{
        return res.json(utils.JParser('Interest deleted error', false, error));
        })
        return res.json(utils.JParser('Interest deleted successfully', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
});

exports.deleteInterest = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastInterest.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('Interest deleted successfully', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
});
