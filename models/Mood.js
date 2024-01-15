// models/mood.js
const mongoose = require('mongoose');


  
  
const moodSchema = new mongoose.Schema({
  userId: {
    type: Number,
    required: true,
  },
  emoji: {
    type: String,
    required: true,
  },
  date: {
    type: String,
    required: true,
    
  },
});

const Mood = mongoose.model('Mood', moodSchema);

module.exports = Mood;
