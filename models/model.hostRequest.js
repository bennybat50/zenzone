const mongoose = require('mongoose')

const MindCastHostRequestSchema=new mongoose.Schema({
    userID:{
        type:String, 
    },
    reason:{
        type:String,  
    },
    experience:{
        type:String,
    },
    buildCommunity:{
        type:String,
    },
    approved:{
        type:String,
        enum : ['pending','approved','revoked'],
        default: 'pending'
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastHostRequest=mongoose.model("mindCastHostRequest", MindCastHostRequestSchema)

module.exports=MindCastHostRequest