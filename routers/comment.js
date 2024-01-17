// Import necessary modules and models
const express = require('express');
const router = express.Router();
const Comment = require('../models/Comment');
const Post=require('../models/Posts');
const mongoose = require('mongoose');
// Route to create a new comment
router.get('/comment/:postId', async (req, res) => {
  try {
      let comment = await Comment.find({ postId: req.params.postId });
      if (!comment) {
          return res.status(404).send({ error: 'comment not found' });
      }
      res.send(comment);
  } catch (e) {
      res.status(500).send(e);
  }
});

router.put("/comments/add", async (req, res) => {
  try {
    const { content, postId, userId,commentOwnerName,commentOwnerImage} = req.body;

    // Check if the post exists
    const post = await Post.findOne({ postId: postId });
    if (!post) {
      return res.status(404).json({ error: `Post with ID ${postId} not found` });
    }

    // Create a new comment
    const comment = new Comment({ content, postId,userId,commentOwnerName,commentOwnerImage });

    // Save the comment
    await comment.save();

    // Update the post with the new comment
    post.comments.push(comment);
    await post.save();

    res.status(201).json({ comment });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});
// Route to get all comments
router.get("/comments/all", async (req, res) => {
  try {
    // Fetch all comments
    const comments = await Comment.find();

    // Return the comments
    res.status(200).json({ comments });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});
/*
router.put("/Comments/add", async (req, res) => {
  console.log(req.body)
  
  const comment = new Comment(req.body);
  try {
      await comment.save();  // Correct the variable name to `doctor`
      res.status(201).send({ comment });
  } catch (e) {
      res.status(400).send(e);
  }
});
*/

// Export the router
module.exports = router;
