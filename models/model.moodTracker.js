const mongoose = require('mongoose')

const MoodTrackerSchema=new mongoose.Schema({
    userID:{
        type:String, 
    },
    mood:{
        type:String,  
    },
    day: {
        type: Number,
    },
    month: {
        type: Number,
    },
    date: {
        type: String,
    },
    time_created:{type:Number, default:()=>Date.now()},	
    updated_at:{type:Number, default:()=>Date.now()}	
})


const MoodTracker=mongoose.model("moodtracker", MoodTrackerSchema)

module.exports=MoodTracker