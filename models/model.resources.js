const mongoose = require('mongoose')

const MindCastResourceSchema=new mongoose.Schema({
    title:{
        type:String,
    },
    userID:{
        type:String, 
    },
    description:{
        type:String,
    },
    image:{
        type:String,    
    },
    file:{
        type:String,    
    },
    thumbnail:{
        type:String,  
    },
    duration:{
        type:String,  
    },
    interestID: {
        type: String,
    },
    resourceType:{
        type:Array,
    },
    resourceUrl:{
        type:String,
    },
    moodType:{
        type:String,
    },
    no_plays:{
        type:Number,
        default:0
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastResource=mongoose.model("mindCastResource", MindCastResourceSchema)

module.exports=MindCastResource