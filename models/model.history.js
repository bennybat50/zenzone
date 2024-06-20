const mongoose = require('mongoose')

const MindCastHistorySchema=new mongoose.Schema({
    userID:{
        type:String, 
    },
    timeStop:{
        type:String,  
    },
    resourceID: {
        type: String,
    },
    percentage:{
        type:String,
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastHistory=mongoose.model("mindCastHistory", MindCastHistorySchema)

module.exports=MindCastHistory