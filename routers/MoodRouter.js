// routes/moods.js
const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const Mood = require('../models/Mood');

// Function to get the emoji percentages for a user
router.get('/emojiPercentages/:userId', async (req, res) => {
  try {
    const userId = req.params.userId;

    // Get all moods for the user
    const allMoods = await Mood.find({ userId });

    // Count the occurrences of each emoji
    const emojiCounts = allMoods.reduce((counts, mood) => {
      counts[mood.emoji] = (counts[mood.emoji] || 0) + 1;
      return counts;
    }, {});

    // Calculate the percentage for each emoji
    const totalMoods = allMoods.length;
    const emojiPercentages = {};
    const emojis = ['😂', '😊', '😇', '🥺', '😢', '😡'];

    emojis.forEach((emoji) => {
      const count = emojiCounts[emoji] || 0;
      const percentage = (count / totalMoods) * 100;
      emojiPercentages[emoji] = percentage.toFixed(2); // Round to 2 decimal places
    });
    console.log(`Received request for emojiPercentages for user ${userId}`);

    res.json(emojiPercentages);
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

router.post('/insertmood/:userId', async (req, res) => {
  try {
    const userId = req.params.userId;
    const moodValue = req.body.moodValue;

    // Create a new Mood instance
    const newMood = new Mood({
      userId,
      emoji: moodValue,
      date: new Date(),
    });

    // Save the new mood to the database
    const savedMood = await newMood.save();

    res.json(savedMood);
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Function to check if the user has already saved an emoji for today
router.get('/hasEmojiForToday/:userId', async (req, res) => {
  try {
    const userId = req.params.userId;

    // Get today's date
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Check if there's a mood entry for today
    const moodForToday = await Mood.findOne({
      userId,
      date: { $gte: today },
    });

    const hasEmojiForToday = !!moodForToday;

    res.json({ hasEmojiForToday });
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

module.exports = router;
