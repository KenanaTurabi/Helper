const express = require('express');
const router = express.Router();
const Appointment = require('../models/Appointment');
const Patient = require('../models/Patient');
const Doctor = require('../models/Doctor');



let lastAppointmentId = 0;

async function initializeLastUserId() {
  const lastAppointment = await Appointment.findOne().sort({ appointmentId: -1 }).limit(1);
  lastAppointmentId = lastAppointment ? lastAppointment.appointmentId : 0;
}

initializeLastUserId();
// Endpoint to create a new appointment
router.post('/appointments', async (req, res) => {
  try {
    const {
      patientId,
      specialistId,
      meetingType,
      doctor,
      eventTitle,
      availableTimes,
      eventDate,
    } = req.body;

    // Assuming the 'doctor' field is an object with 'name' and 'image'
    const { name, image } = doctor;
    lastAppointmentId++;
    const newAppointment = new Appointment({
      appointmentId:lastAppointmentId,
      patientId,
      specialistId,
      meetingType,
      doctor: {
        name,
        image,
      },
      eventTitle,
      availableTimes,
      eventDate: new Date(eventDate),
    });

    // Save the appointment to the database
    await newAppointment.save();

    res.status(201).json({ message: 'Appointment created successfully' });
  } catch (error) {
    console.error('Error creating appointment:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.get('/appointments/:patientId', async (req, res) => {
  try {
    const patientId = req.params.patientId;

    // Find appointments for the specified patientId
    const appointments = await Appointment.find({ patientId });

    // Fetch CurrentWorkPlace for each appointment
    const appointmentsWithCurrentWorkplace = await Promise.all(
      appointments.map(async (appointment) => {
        const specialistId = appointment.specialistId; // Assuming 'specialistId' is the reference to Doctor in the Appointment model
        const doctor = await Doctor.findOne({ id: specialistId });
        const currentWorkplace = doctor ? doctor.CurrentWorkPlace : null;
        return {
          ...appointment.toObject(),
          currentWorkplace,
        };
      })
    );

    console.log('Appointments with CurrentWorkPlace:', appointmentsWithCurrentWorkplace);
    res.status(200).json({ appointments: appointmentsWithCurrentWorkplace });
  } catch (error) {
    console.error('Error fetching appointments:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});




  
  router.get('/appointments_specialists/:specialistId', async (req, res) => {
    try {
      const specialistId = req.params.specialistId;
      console.log('Fetching appointments for specialistId:', specialistId);

      // Find appointments for the specified specialistId
      const appointments = await Appointment.find({ specialistId: specialistId });
      console.log('Appointments:', appointments);

      // Initialize an array to store appointment details with patient information
      const appointmentsWithPatientInfo = [];
  
      // Iterate through each appointment
      for (const appointment of appointments) {
        // Find patient details for the current appointment
        const patientDetails = await Patient.findOne({ id: appointment.patientId });
  
        // If patient details are found, add them to the appointment
        if (patientDetails) {
          const appointmentWithPatientInfo = {
            ...appointment.toObject(),
            patient: {
              name: patientDetails.name,
              image: patientDetails.image,
            },
          };
          appointmentsWithPatientInfo.push(appointmentWithPatientInfo);
        }
      }
  
      console.log('Appointments with patient info:', appointmentsWithPatientInfo);
      res.status(200).json({ appointments: appointmentsWithPatientInfo });
    } catch (error) {
      console.error('Error fetching appointments:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  });
  
  module.exports = router;
  

module.exports = router;
