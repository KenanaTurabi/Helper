const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const patientSchema = new Schema({
  name: String,
  id: Number,
  email: String,

  image: {
    type: String,
    default: 'no-profile-image.png',
  },
  mobileNumber: {
    type: Number,
    default: 0, // Set default value for mobileNumber
  },
  city: {
    type: String,
    default: '', // Set default value for country
  },
});

const Patient = mongoose.model('Patient', patientSchema);
module.exports = Patient;
