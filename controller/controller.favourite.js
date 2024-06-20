const express = require('express')
const dotenv = require("dotenv")
dotenv.config()
const { useAsync, utils, errorHandle, } = require('./../core');
const MindCastUser = require('../models/model.user');
const MindCastFavourite = require('../models/model.favourites');



exports.favourite = useAsync(async (req, res) => {

    try{

        const favourite = await MindCastFavourite.create(req.body)
        return res.json(utils.JParser('Favourite created successfully', !!favourite, favourite));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})

exports.singleFavourite = useAsync(async (req, res) => {

    try {
        const favourite = await MindCastFavourite.findOne({ _id: req.params.id });
        return res.json(utils.JParser('Favourite fetch successfully', !!favourite, favourite));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.allFavourite = useAsync(async (req, res) => {

    try {
        const favourite = await MindCastFavourite.find();
        return res.json(utils.JParser('Favourite fetch successfully', !!favourite, favourite));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.userFavourite = useAsync(async (req, res) => {

    try {
        const favourite = await MindCastFavourite.find({ userID: req.params.id });
        return res.json(utils.JParser('User Favourite fetch successfully', !!favourite, favourite));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.deleteFavourite = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastFavourite.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('Favourite deleted successfully', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

});
