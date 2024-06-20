const mongoose = require('mongoose')

const MindCastSubscriptionSchema=new mongoose.Schema({
    name:{
        type:String,
    },
    duration:{
        type:Number,
    },
    price:{
        type:Number,    
    },
    description:{
        type:String,
    },
    type: {
        type: String,
        enum : ['monthly','weekly','daily'],
        default: 'monthly'
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastSubscription=mongoose.model("mindCastSubscription", MindCastSubscriptionSchema)

module.exports=MindCastSubscription