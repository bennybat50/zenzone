const express = require('express')
const dotenv = require("dotenv")
dotenv.config()
const { useAsync, utils, errorHandle, } = require('./../core');
const MindCastUser = require('../models/model.user');
const MindCastHistory = require('../models/model.history');



exports.history = useAsync(async (req, res) => {

    try{

        const history = await MindCastHistory.create(req.body)
        return res.json(utils.JParser('History created successfully', !!history, history));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})

exports.singleHistory = useAsync(async (req, res) => {

    try {
        const history = await MindCastHistory.findOne({ _id: req.params.id });
        return res.json(utils.JParser('History fetch successfully', !!history, history));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.allHistory = useAsync(async (req, res) => {

    try {
        const history = await MindCastHistory.find();
        return res.json(utils.JParser('History fetch successfully', !!history, history));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.userHistory = useAsync(async (req, res) => {

    try {
        const history = await MindCastHistory.find({ userID: req.params.id });
        return res.json(utils.JParser('User History fetch successfully', !!history, history));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.deleteHistory = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastHistory.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('History deleted successfully', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

});
