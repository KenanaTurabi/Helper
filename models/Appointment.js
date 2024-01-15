const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Define Doctor schema
const doctorSchema = new Schema({
  name: {
    type: String,
    required: true,
  },
  image: {
    type: String,
    required: true,
  },
});

// Define Event schema
const AppointmentSchema = new Schema({
  appointmentId: {
    type: Number,
    required: true,
  },
  patientId: {
    type: Number,
    required: true,
  },
  specialistId: {
    type: Number,
    required: true,
  },
  meetingType: {
    type: String,
    required: true,
  },
  doctor: {
    type: doctorSchema,
    required: true,
  },
  eventTitle: {
    type: String,
    required: true,
  },
  availableTimes: {
    type: String,
    required: true,
  },
  eventDate: {
    type: Date,
    required: true,
  },
});

// Create the Event model
const Appointment = mongoose.model('Appointment', AppointmentSchema);

module.exports = Appointment;
