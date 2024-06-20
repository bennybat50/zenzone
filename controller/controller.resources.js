const express = require('express')
const dotenv = require("dotenv")
dotenv.config()
const { useAsync, utils, errorHandle, } = require('./../core');
const MindCastUser = require('../models/model.user')
const MindCastResource = require('../models/model.resources')
const MindCastInterest = require('../models/model.interest');



exports.resources = useAsync(async (req, res) => {

    try {

        const audit = await MindCastResource.create(req.body)
        return res.json(utils.JParser('Resources created successfully', !!audit, audit));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

})

exports.resourceUpdate = useAsync(async (req, res) => {

    try {
        // const id = req.userId;
        const id = req.params.id;
        const body = req.body
        await MindCastResource.updateOne({ _id: id }, body).then(async () => {
            const resource = await MindCastResource.find({ _id: id });
            return res.json(utils.JParser('Resources Updated  Successfully', !!resource, resource));
        })

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})


exports.singleResources = useAsync(async (req, res) => {
    try {
        const resources = await MindCastResource.findOne({ _id: req.params.id });
        return res.json(utils.JParser('Resources fetch successfully', !!resources, resources));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.updatePlayCount = useAsync(async (req, res) => {
    try {
        let resource = null
        await MindCastResource.findOne({ _id: req.params.id }).then(async (data) => {
            let count=data.no_plays
            await MindCastResource.updateOne({ _id: req.params.id },{no_plays: count + 1}).then(async () => {
                resource = await MindCastResource.findOne({ _id: req.params.id })
            })
        });
        return res.json(utils.JParser('Resource fetch successfully', !!resource, resource));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.allResources = useAsync(async (req, res) => {
    try {
        const resources = await MindCastResource.find();
        return res.json(utils.JParser('Resources fetch successfully', !!resources, resources));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.highResources = useAsync(async (req, res) => {
    try {
        let resources = await MindCastResource.find();
        resources=resources.sort((a,b)=>  b.no_plays - a.no_plays)
        return res.json(utils.JParser('Resources fetch successfully', !!resources, resources));
    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.userResources = useAsync(async (req, res) => {

    try {

        let resources = await MindCastResource.find({ userID: req.params.id });

        return res.json(utils.JParser('User resources fetch successfully', !!resources, resources));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.searchResources = useAsync(async (req, res) => {

    try {

        let resources = await MindCastResource.find({ $or: [{ title: { $regex: req.body.query, $options: 'i' } }, { description: { $regex: req.body.query,$options: 'i' } }] });

        let hosts = await MindCastUser.find({ isHost: true, $or: [{ username: { '$regex': req.body.query } }] });

        return res.json(utils.JParser('Search results fetch successfully', !!resources, { resources, hosts }));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.interestResources = useAsync(async (req, res) => {

    try {

        let resources = await MindCastResource.find({ interestID: req.params.id });

        return res.json(utils.JParser('Interest resources fetch successfully', !!resources, resources));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.interestAndResources = useAsync(async (req, res) => {

    try {

        let resources = await MindCastResource.find();
        let interests = await MindCastInterest.find();
        let interest_resources = []

        interests.forEach(interest => {
            let resource = []
            resources.forEach(reso => {
                if (reso.interestID == interest._id) {
                    resource.push(reso)
                }

            })

            interest_resources.push({ interest, resource })
        })


        return res.json(utils.JParser('Interest resources fetch successfully', !!interest_resources, interest_resources));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }
})

exports.deleteResources = useAsync(async (req, res) => {
    try {
        if (!req.body.id) return res.status(402).json({ msg: 'provide the id ' })

        await MindCastResource.deleteOne({ _id: req.body.id })
        return res.json(utils.JParser('Resources deleted successfully', true, []));

    } catch (e) {
        throw new errorHandle(e.message, 400)
    }

});
