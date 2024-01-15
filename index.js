const app = require('express')();
const http = require('http').Server(app);
const express = require("express");
app.use(express.json());

 const mongoose = require('mongoose');
 mongoose.connect("mongodb+srv://kenanaturabi:CalmMind123@kenana.u3boik7.mongodb.net/");
 const User=require('./models/User');
 const Post=require('./models/Posts');
 const Doctor =require('./models/Doctor');
const Patient=require('./models/Patient');
const Comments=require('./models/Comment');

const TreatmentPlan=require('./models/TreatmentPlan');
const Session=require('./models/Person');
const Mood=require('./models/Mood');

 const doctorRouter = require("./routers/doctor");
 const commentRouter = require("./routers/comment");

 const patientRouter = require("./routers/patient");
 const personRouter = require("./routers/person");
 const PostRouter = require("./routers/post");
 const userRoutes = require("./routers/userRoutes");
 const bookingRoutes = require('./routers/BookingRoutes'); // Import user routes
const treatmentplanRouter=require('./routers/TreatmentPlan');
const sessionRouter=require('./routers/SessionRoutes');
const moodRouter=require('./routers/MoodRouter');

 const bodyParser = require("body-parser");
const port = process.env.PORT || 5000;

app.use(bodyParser.urlencoded({ extended: true }));

app.use(doctorRouter);
app.use(patientRouter);
app.use(personRouter);
app.use(userRoutes);
app.use(PostRouter);
app.use(bookingRoutes);
app.use(treatmentplanRouter);
app.use(sessionRouter);
app.use(moodRouter);
app.use(commentRouter);







app.use(express.static("public"));
app.get("/", function (req, res) {
  res.sendFile(__dirname+"/public/index.html");
});


http.listen(5000, function(){
    console.log('Server is running');
})

/*



 async function insertUser(){
     await User.create({
         id:1,
         name: 'ahmad',
         email:'ahmad@gmail.com'
     });
    }





    




    async function insertPost(){
        await Post.create({
            postContent: 'follow this tips for getting a healthy mind life',
            image:'https://media.istockphoto.com/id/1293388093/photo/two-men-exercising.jpg?s=2048x2048&w=is&k=20&c=8hUj3Sjas4nXGaYR298kgpQGi3DU3QJbmMf4-jYoRiA=',
            isFavourite:false,
            userid:1
        });
       }
       async function insertUser2() {
        try {
            await User.create({
                id: 2,
                name: 'John Doe',
                email: 'john.doe@example.com'
            }, { timeout: 15000 }); // Increase the timeout to 15 seconds
            console.log('User 2 inserted successfully');
        } catch (error) {
            console.error('Error inserting user 2:', error);
        }
    }
    
    
    async function insertPost2() {
        try {
            await Post.create({
                postContent: 'follow this tips for getting a healthy mind life',
                image: 'https://media.istockphoto.com/id/1293388093/photo/two-men-exercising.jpg?s=2048x2048&w=is&k=20&c=8hUj3Sjas4nXGaYR298kgpQGi3DU3QJbmMf4-jYoRiA=',
                isFavourite: false,
                userid: 2
            });
            console.log('Post 2 inserted successfully');
        } catch (error) {
            console.error('Error inserting post 2:', error);
        }
    }
    
    //    async function insertDoctor(){
    //     await Doctor.create({
    //         id:1,
    //         name: 'ahmad',
    //         email:'ahmad@gmail.com',
    //         specialization: 'specialize in ....',
    //         CurrentWorkPlace:'Nablus',
    //         yearsOfExperience:3,
    //         image:'https://media.istockphoto.com/id/1293388093/photo/two-men-exercising.jpg?s=2048x2048&w=is&k=20&c=8hUj3Sjas4nXGaYR298kgpQGi3DU3QJbmMf4-jYoRiA=',
    //         mobileNumber:44596,
    //         country:'Palestine'


    //     });
    //    }

    
//insertUser2();
//insertPost2();
//insertDoctor();



*/