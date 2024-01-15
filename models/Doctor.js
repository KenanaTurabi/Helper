const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const doctorSchema = new Schema({
  name: String,
  id: Number,
  email: String,
  specialization: {
    type: String,
    default: '', // Set default value to an empty string
  },
  CurrentWorkPlace: {
    type: String,
    default: '', // Set default value to an empty string
  },
  yearsOfExperience: {
    type: Number,
    default: 0, // Set default value to 0
  },
  image: {
    type: String,
    default: 'no-profile-image.png',
  },
  mobileNumber: {
    type: Number,
    default: 0, // Set default value to 0
  },
  city: {
    type: String,
    default: '', // Set default value to an empty string
  },
  isPending: {
    type: Boolean,
    default: true, // Set default value to an empty string
  },
});

const Doctor = mongoose.model('Doctor', doctorSchema);

module.exports = Doctor;
