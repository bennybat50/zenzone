const mongoose = require('mongoose')

const MindCastBookmarkSchema=new mongoose.Schema({
    userID:{
        type:String, 
    },
    type:{
        type:String, 
    },
    resourceID:{
        type:String,  
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastBookmark=mongoose.model("mindCastBookmark", MindCastBookmarkSchema)

module.exports=MindCastBookmark