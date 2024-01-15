const express = require('express');
const router = express.Router();
const TreatmentPlan = require('../models/TreatmentPlan');
const Patient = require('../models/Patient');

// Route to handle saving TreatmentPlan data
router.post('/saveTreatmentPlan', async (req, res) => {
  try {
    const { userId, diagnoses, tasks } = req.body;

    // Check if the patient already has a treatment plan
    const existingTreatmentPlan = await TreatmentPlan.findOne({ userId });

    if (existingTreatmentPlan) {
      // If a treatment plan exists, update the existing one
      existingTreatmentPlan.diagnoses = diagnoses;
      existingTreatmentPlan.tasks = tasks;
      const updatedTreatmentPlan = await existingTreatmentPlan.save();

      res.status(200).json(updatedTreatmentPlan);
    } else {
      // If no treatment plan exists, create a new one
      const newTreatmentPlan = new TreatmentPlan({
        userId,
        diagnoses,
        tasks,
      });

      const savedTreatmentPlan = await newTreatmentPlan.save();

      res.status(201).json(savedTreatmentPlan);
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


router.get('/getTreatmentPlan/:id', async (req, res) => {
  try {
    const userId = req.params.id;

    // Find the patient by userId to get the name
    const patient = await Patient.findOne({ id: userId});

    if (!patient) {
      // If no patient is found, return a 404 status
      return res.status(404).json({ error: 'Patient not found' });
    }

    // Get the patient's name
    const patientName = patient.name;

    // Now, find the TreatmentPlan by patient's name
    const treatmentPlan = await TreatmentPlan.findOne({ userId });

    if (!treatmentPlan) {
      // If no treatment plan is found, return a 404 status
      return res.status(404).json({ error: 'Treatment Plan not found' });
    }

    res.status(200).json({
      patientName: patientName,
      treatmentPlan: treatmentPlan,
    });
    } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



module.exports = router;
