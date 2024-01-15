const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const taskSchema = new Schema({
  name: String,
  description: String,
});

const treatmentPlanSchema = new Schema({
  userId: {
    type: String, // Assuming userId is a string, you can adjust the type accordingly
    required: true,
  },
  diagnoses: {
    type: String,
    default: 'No diagnoses', // Set default value to 'No diagnoses'
  },
  tasks: {
    type: [taskSchema],
    default: [], // Set default value to an empty array
  },
});

const TreatmentPlan = mongoose.model('TreatmentPlan', treatmentPlanSchema);

module.exports = TreatmentPlan;
