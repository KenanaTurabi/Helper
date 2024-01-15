const express = require('express');
const router = express.Router();
const bodyParser = require('body-parser'); // Import body-parser
const User = require('../models/User');
const Doctor = require('../models/Doctor'); // Import the Doctor model
const Patient = require('../models/Patient'); // Import the Doctor model
const bcrypt = require('bcrypt'); // Import bcrypt for password hashing

// Use bodyParser middleware to parse JSON
router.use(bodyParser.json());
let lastUserId = 0;

async function initializeLastUserId() {
  const lastUser = await User.findOne().sort({ userId: -1 }).limit(1);
  lastUserId = lastUser ? lastUser.userId : 0;
}

initializeLastUserId();
//Sign up
router.post('/users', async (req, res) => {
  try {
    const { fullname, email, password, userType } = req.body;
  

    
   // Check if the email already exists
   const existingUser = await User.findOne({ email });

   if (existingUser) {
     return res.status(400).json({ error: 'Email already exists' });
   }
   lastUserId++;

    const newUser = new User({
      userId: lastUserId,
      fullname,
      email,
      password, 
      userType,
    });

    await newUser.save();

    console.log('User inserted successfully');

    if (userType === 'specialist') {
      // If the user is a specialist, save doctor information to Doctor collection
      const newDoctor = new Doctor({
        name: fullname,
        id: lastUserId,
        email,
        // Add more fields as needed
      });

      await newDoctor.save();

      console.log('Doctor information saved successfully');
    }
    else if (userType === 'patient') {
      // If the user is a patient, save patient information to Patient collection
      const newPatient = new Patient({
        name: fullname,
        id: lastUserId,
        email,
      });

      await newPatient.save();

      console.log('Patient information saved successfully');
    }
    res.status(201).json({ message: 'User created successfully',  user: newUser.toObject(), userId: lastUserId, userType: newUser.userType,  });
  } catch (error) {
    console.error('Error creating user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

//sign in

router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Check if the email exists
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Simple string comparison (not recommended for production)
    if (password !== user.password) {
      return res.status(401).json({ error: 'Invalid password' });
    }

    // User is authenticated
    res.status(200).json({ message: 'Login successful', user: user.toObject(), userId: user.userId, userType: user.userType, });
  } catch (error) {
    console.error('Error during login:', error);
    res.status(500).json({ error: 'Internal server error during login' });
  }
});

//get all doctors

router.get('/specialists', async (req, res) => {
  try {
    // Query the database to find all doctors
    const specialists = await Doctor.find({}, 'id name image CurrentWorkPlace');

    // Send the list of doctors to the frontend
    res.json({ specialists });
  } catch (error) {
    console.error('Error fetching doctors:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.get('/User/:id', async (req, res) => {
  try {
      let user = await User.findOne({ userId: req.params.id });
      if (!user) {
          return res.status(404).send({ error: 'user not found' });
      }
      res.send(user);
  } catch (e) {
      res.status(500).send(e);
  }
});
module.exports = router;
