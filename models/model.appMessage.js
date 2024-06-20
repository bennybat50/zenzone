const mongoose = require('mongoose')

const MindCastAppMessageSchema=new mongoose.Schema({
    title:{
        type:String,
    },
    message:{
        type:String, 
    },
    image:{
        type:String, 
    },
    status:{
        type:String, 
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastAppMessage=mongoose.model("mindCastAppMessage", MindCastAppMessageSchema)

module.exports=MindCastAppMessage
