const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const Session = require('../models/Session');
const Doctor = require('../models/Doctor'); // Assuming you have a Doctor model

let lastsessionId = 0;

async function initializeLastSessionId() {
  const lastSession = await Session.findOne().sort({ sessionId: -1 }).limit(1);
  lastsessionId = lastSession ? lastSession.sessionId : 0;
}

initializeLastSessionId();

router.post('/create-session', async (req, res) => {
  try {
    // Extract data from the request body
    const { specialistId, subject, time, Session_Date } = req.body;

    // Validate data (you can add more validation as needed)
    if (!specialistId || !Session_Date) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Retrieve doctor details based on specialistId
    const doctor = await Doctor.findOne({ id:specialistId });

    if (!doctor) {
      return res.status(404).json({ error: 'Doctor not found for the given specialistId' });
    }

    lastsessionId++;

    // Create a new Session instance
    const newSession = new Session({
      specialistId,
      sessionId:lastsessionId,
      doctorname: doctor.name,
      doctorimage: doctor.image,
      subject,
      time,
      Session_Date: new Date(Session_Date),
    });

    // Save the new session to the database
    await newSession.save();

    res.status(201).json({ message: 'Session created successfully', session: newSession });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.get('/sessions/:specialistId', async (req, res) => {
    try {
      const specialistId = req.params.specialistId;
  
      // Find sessions for the specified specialistId
      const sessions = await Session.find({ specialistId });
  
      res.status(200).json({ sessions });
    } catch (error) {
      console.error('Error fetching sessions:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  });
  router.get('/sessions', async (req, res) => {
    try {
        // Find all sessions
        const sessions = await Session.find();
  
        res.status(200).json({ sessions });
    } catch (error) {
        console.error('Error fetching sessions:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

  

module.exports = router;
