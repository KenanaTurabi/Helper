const mongoose = require('mongoose');

const commentSchema = new mongoose.Schema({
  content: {
    type: String,
    required: true,
  },
  commentOwnerName: {
    type: String,
    required: true,
  },
  postId: {
    type: Number, // Keep the type as Number
    required: true,
  },
  userId: {
    type: Number, // Keep the type as Number
    required: true,
  },
});

const Comment = mongoose.model('Comment', commentSchema);

module.exports = Comment;