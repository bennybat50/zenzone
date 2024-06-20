const express = require('express')
const dotenv = require("dotenv")
dotenv.config()
const { useAsync, utils, errorHandle, } = require('../core');
const MindCastUser = require('../models/model.user')
const MindCastRecommend= require('../models/model.recommend');



exports.recommend = useAsync(async (req, res) => {
    try{
        const recommend = await MindCastRecommend.create(req.body)
        return res.json(utils.JParser('recommend created successfully', !!recommend, recommend));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})

exports.singleRecommend = useAsync(async (req, res) => {

    try {
        const recommend = await MindCastRecommend.findOne({ _id: req.params.id });
        return res.json(utils.JParser('recommend fetch successfully', !!recommend, recommend));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.interestRecommend= useAsync(async (req, res) => {

    try {
        const recommend = await MindCastRecommend.find({ interestID: req.params.id });
        return res.json(utils.JParser('Interest Recomend fetch successfully', !!recommend, recommend));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.allRecommend = useAsync(async (req, res) => {
    try {
        const recommend = await MindCastRecommend.find();
        return res.json(utils.JParser('recommend fetch successfully', !!recommend, recommend));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

// exports.interestRecommend= useAsync(async (req, res) => {
//     try {
//         const recommend = await MindCastRecommend.find({ resourceID: req.params.id });
//         return res.json(utils.JParser('Interest recommend fetch successfully', !!recommend, recommend));
//     } catch (e) {
//         throw new errorHandle(e.message, 400)
//     }
// })

exports.deleteRecommend = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastRecommend.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('recommend deleted successfully', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

});