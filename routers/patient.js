const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const Patient = require('../models/Patient');
const Appointment = require('../models/Appointment');

router.get('/patientsBySpecialist/:specialistId', async (req, res) => {
  try {
    const { specialistId } = req.params;

    // Find appointments with the given specialistId
    const appointments = await Appointment.find({ specialistId });

    // Extract unique patientIds from appointments
    const patientIds = [...new Set(appointments.map(appointment => appointment.patientId))];

    // Fetch patient information for each patientId
    const patients = await Patient.find({ id: { $in: patientIds } });

    res.json(patients);
  } catch (error) {
    console.error('Error fetching patients:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.get('/patients', async (req, res) => {
  try {
    const patients = await Patient.find({}, 'id name email image mobileNumber city');
    res.json(patients);
  } catch (error) {
    console.error('Error fetching patients:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});


module.exports = router;
