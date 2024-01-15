const mongoose = require('mongoose');

const sessionSchema = new mongoose.Schema({
  specialistId: {
    type: Number,
    required: true,
  },
  sessionId: {
    type: String,
    required: true,
    unique: true,
  },
  doctorname: {
    type: String,
    required: true,
  },
  doctorimage: {
    type: String,
    required: true,
  },
  subject: {
    type: String,
  },
  time: {
    type: String,
  },
  Session_Date: {
    type: Date,
    required: true,
  },
});

const Session = mongoose.model('Session', sessionSchema);

module.exports = Session;
