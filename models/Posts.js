
const mongoose = require('mongoose');

const postSchema = new mongoose.Schema({
    postContent: {
      type: String,
      required: true,
    },
    image: {
      type: String,
      required: true,
    },
    userId: {
      type: Number,
      required: true,
    },

    likeCount: {
      type: Number,
      required: true,
    },
    postId: {
      type: Number,
      required: true,
    },
    comments: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Comment', // Assuming Comment is the model for comments
      }
    ],
    likes: [
      {
        type: Number,
      }
    ],
    createdAt: {
      type: String,
      required: true,
    },
    userName: String, // Add this field
    profileImage: String, // Add this field
  });
  
  const Post = mongoose.model('Post', postSchema);
  
  module.exports = Post;
  