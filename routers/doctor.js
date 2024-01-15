const express= require('express')
const router=new express.Router()
const mongoose = require('mongoose');
const Doctor = require('../models/Doctor')


//doctor list4
router.get('/Doctors', async (req, res) => {
    try {
        let doctors = await Doctor.find();
        res.json(doctors);
    } catch (e) {
        res.status(400).send(e);
        console.log(e);
    }
});
// Example route for handling doctor acceptance
router.put('/doctors/accept/:id', async (req, res) => {
    try {
        const doctorId = req.params.id;
        // Add logic to update the isPending status to false for the accepted doctor
        const acceptedDoctor = await Doctor.findOneAndUpdate(
            { id: doctorId },
            { isPending: false },
            { new: true }
        );

        if (!acceptedDoctor) {
            return res.status(404).send({ error: 'Doctor not found' });
        }

        res.status(200).send({ message: 'Doctor accepted successfully' });
    } catch (e) {
        console.error(e);
        res.status(500).send({ error: 'Internal Server Error' });
    }
});


router.put("/Doctors/add", async (req, res) => {
    console.log(req.body)
    
    const doctor = new Doctor(req.body);
    try {
        await doctor.save();  // Correct the variable name to `doctor`
        res.status(201).send({ doctor });
    } catch (e) {
        res.status(400).send(e);
    }
});
// Example route for handling DELETE requests for doctors
router.delete('/doctors/:id', async (req, res) => {
    try {
        const doctorId = req.params.id;

        // Check if the doctor with the given ID exists
        const doctor = await Doctor.findOne({ id: doctorId });

        if (!doctor) {
            return res.status(404).send({ error: 'Doctor not found' });
        }

        // Add logic to delete the doctor with the given ID
        await Doctor.deleteOne({ id: doctorId });

        res.status(200).send({ message: 'Doctor deleted successfully' });
    } catch (e) {
        console.error(e);
        res.status(500).send({ error: 'Internal Server Error' });
    }
});


router.get('/Doctor/:id', async (req, res) => {
    try {
        let doctor = await Doctor.findOne({ id: req.params.id });
        if (!doctor) {
            return res.status(404).send({ error: 'doctor not found' });
        }
        res.send(doctor);
    } catch (e) {
        res.status(500).send(e);
    }
});






module.exports=router