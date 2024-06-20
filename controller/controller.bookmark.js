const express = require('express')
const dotenv = require("dotenv")
dotenv.config()
const { useAsync, utils, errorHandle, } = require('./../core');
const MindCastUser = require('../models/model.user')
const MindCastBookmark = require('../models/model.bookmark');



exports.bookmark = useAsync(async (req, res) => {

    try{

        const hasMark = await MindCastBookmark.findOne({ resourceID: req.body.resourceID });
        console.log(hasMark);
        if(hasMark!=null){
            await MindCastBookmark.deleteOne({ _id: hasMark._id })
            return res.json(utils.JParser('Resource Unsaved'));
        }else{
            const bookmark = await MindCastBookmark.create(req.body)
            return res.json(utils.JParser('Resource Saved ', !!bookmark, bookmark));
        }
       

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})

exports.singleBookmark = useAsync(async (req, res) => {

    try {
        const bookmark = await MindCastBookmark.findOne({ _id: req.params.id });
        return res.json(utils.JParser('Bookmark fetch successfully', !!bookmark, bookmark));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.allBookmark = useAsync(async (req, res) => {

    try {
        const bookmark = await MindCastBookmark.find();
        return res.json(utils.JParser('Bookmark fetch successfully', !!bookmark, bookmark));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.userSingleBookmark= useAsync(async (req, res) => {

    try {
        var query = {$and:[{userID:{$regex: req.params.userID, $options: 'i'}},{resourceID:{$regex: req.params.resourceID, $options: 'i'}}]}

        const bookmark = await MindCastBookmark.findOne(query);
        if(bookmark!=null){
            return res.json(utils.JParser('User Bookmark fetch successfully', !!bookmark, bookmark));
        }else{
            return res.json(utils.JParser('No favourites yet',!!bookmark));
        }
       
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.userBookmark= useAsync(async (req, res) => {

    try {
        const bookmark = await MindCastBookmark.find({ userID: req.params.id });
        return res.json(utils.JParser('User Bookmark fetch successfully', !!bookmark, bookmark));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.deleteBookmark = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastBookmark.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('Bookmark deleted successfully', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

});