const mongoose = require('mongoose')

const MindCastUserInterestSchema=new mongoose.Schema({
    interest_id:{
        type:String,
    },
    user_id:{
        type:String, 
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastUserInterest=mongoose.model("mindCastUserInterest", MindCastUserInterestSchema)

module.exports=MindCastUserInterest
