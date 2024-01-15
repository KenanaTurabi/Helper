const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const postSchema = new Schema({
  postContent: String,
  image: String,  
  userName:String,
  userPhoto:String,
});

const Post = mongoose.model('Post', postSchema);

module.exports = Post;
