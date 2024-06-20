const mongoose = require('mongoose')

const MindCastRecommendSchema=new mongoose.Schema({
    interestID:{
        type:String, 
    },
    resourceID:{
        type:String,  
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const mindCastRecommend=mongoose.model("mindRecommend", MindCastRecommendSchema)

module.exports=mindCastRecommend