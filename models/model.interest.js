const mongoose = require('mongoose')

const MindCastInterestSchema=new mongoose.Schema({
    name:{
        type:String,
    },
    icon:{
        type:String, 
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastInterest=mongoose.model("mindCastInterest", MindCastInterestSchema)

module.exports=MindCastInterest
