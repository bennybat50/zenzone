const express = require("express")
const app = express()
const expressLayouts = require('express-ejs-layouts');
const cors = require('cors')
const path = require('path');
const bodyParser = require('body-parser')
const mindCastAuth = require('./routes/route.auth')
const mindCastUser = require('./routes/route.user')
const {  userUpdateMood, sendMoodCheck } = require('./controller/controller.user');

const cron=require('node-cron')

const mongoose = require('mongoose');
const { log } = require("console");

// const dotenv = require("dotenv")
// dotenv.config()

app.use(cors());
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header('Access-Control-Allow-Credentials', true);
  res.header('Access-Control-Allow-Methods', 'DELETE, PUT, GET, POST, OPTIONS');
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

app.use(express.urlencoded());  
app.use(express.json());
app.use(expressLayouts);
app.set('view engine', 'ejs');
app.use(express.static(path.join(__dirname, 'public')));
app.use('/docs', express.static(path.join(__dirname, 'docs')));


app.use(bodyParser.json())


app.use("/api/v1/auth", mindCastAuth)
app.use("/api/v1/user", mindCastUser)


mongoose.set("strictQuery", true); 
    mongoose.connect(process.env.MONGO_URL)
    .then(() => {
        console.log("Database Connected")
    })
    .catch((err) => console.log(err));

const port = process.env.PORT || 3005;
app.listen(port, () => {
    cron.schedule("0 0 0 * * *", ()=>{
        userUpdateMood()
        console.log("Task Scheduled successfully");
    })

    // cron.schedule("0 7 * * *", ()=>{
    //     sendMoodCheck()
    //     console.log("Notification sent successfully");
    // })

    cron.schedule("0 20 * * *", ()=>{
        sendMoodCheck()
        console.log("Notification sent successfully");
    })

   

    console.log('Server is running on port ' + port);
})
