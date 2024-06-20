const mongoose = require('mongoose')

const MindCastCuponCodeSchema=new mongoose.Schema({
    coupon:{
        type:String,
    },
    email:{
        type:String,
    },
    duration:{
        type:Number, 
    },
    price:{
        type:Number,    
    },
    assignedName:{
        type:String,    
    },
    userID:{
        type:String,
    },
   
    exp_date: {
        type: Number,
    },
    status: {
        type: String, 
        enum : ['pending','active','expired'],
        default: 'pending'
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastCuponCode=mongoose.model("MindCastCuponCode", MindCastCuponCodeSchema)

module.exports=MindCastCuponCode