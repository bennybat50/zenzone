const mongoose = require('mongoose')

const MindCastReviewSchema=new mongoose.Schema({
    userID:{
        type:String,
    },
    resourceID:{
        type:String, 
    },
    title:{
        type:String,    
    },
    description:{
        type:String,
    },
    rating: {
        type: String,
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastReview=mongoose.model("mindCastReview", MindCastReviewSchema)

module.exports=MindCastReview