const mongoose = require('mongoose')

const MindCastAuditSchema=new mongoose.Schema({
    userID:{
        type:String, 
    },
    actionType:{
        type:String,  
    },
    date: {
        type: String,
    },
    loginAt: {
        type: String,
    },
    message: {
        type: String,
    },
    device: {
        type: String,
    },
    ip:{
        type:String,
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastAudit=mongoose.model("mindCastAudit", MindCastAuditSchema)

module.exports=MindCastAudit