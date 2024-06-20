const mongoose = require('mongoose')

const MindCastAppSchema=new mongoose.Schema({
    v_code:{
        type:String,
    },
    v_name:{
        type:String, 
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MindCastApp=mongoose.model("mindCastApp", MindCastAppSchema)

module.exports=MindCastApp
