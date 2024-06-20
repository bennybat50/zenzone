const mongoose = require('mongoose')

const MindCastFavouriteSchema=new mongoose.Schema({
    userID:{
        type:String, 
    },
    resourceID:{
        type:String,
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastFavourite=mongoose.model("mindCastFavourite", MindCastFavouriteSchema)

module.exports=MindCastFavourite