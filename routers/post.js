const express = require('express');
const router = new express.Router();
const mongoose = require('mongoose');
const Post = require('../models/Posts');
const { ObjectId } = require('mongoose').Types; // Import ObjectId
const User = require('../models/User');
const Doctor = require('../models/Doctor'); // Import Doctor model
const Patient = require('../models/Patient'); // Import Patient model
const axios = require('axios');



/*
router.post('/posts/like/:postId', async (req, res) => {
  const postId = req.params.postId;

  try {
    const post = await Post.findById(postId);

    if (!post) {
      return res.status(404).json({ error: 'Post not found' });
    }

    // Check if the user has already liked the post
    if (post.likes.includes(req.body.userId)) {
      return res.status(400).json({ error: 'Post already liked' });
    }

    // Add user to the list of likes
    post.likes.push(req.body.userId);
    post.likeCount = post.likes.length;

    await post.save();
    res.status(200).json({ message: 'Post liked successfully', likeCount: post.likeCount });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});
*/

router.get('/GetUserDetails/:userId', async (req, res) => {
    try {
      const userId = req.params.userId;
  
      const user = await User.findOne({ userId: userId });
  
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      let userDetails;
  
      if (user.userType === 'patient') {
        userDetails = await Patient.findOne({ id: userId });
      } else if (user.userType === 'specialist') {
        userDetails = await Doctor.findOne({ id: userId });
      }
  
      if (!userDetails) {
        return res.status(404).json({ error: 'User details not found' });
      }
  
      const { name, image } = userDetails;
      res.status(200).json({ name, image });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  }
  );
  

// Route to create a new post
router.put("/Posts/add", async (req, res) => {
  console.log("PUT request received at /Posts/add");
  const post = new Post(req.body); // Use Post directly
  try {
    await post.save();
    res.status(201).send({ post });
  } catch (e) {
    res.status(400).send(e);
  }
});

// Route to get all posts
router.get('/posts', async (req, res) => {
  try {
    let posts = await Post.find();
    res.json(posts);
  } catch (e) {
    res.status(400).send(e);
    console.log(e);
  }
});

// Route to create a new post
router.post('/Addposts', async (req, res) => {
  try {
    const { postContent, image, userId } = req.body;
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    const post = new Post({ postContent, image, userId });
    await post.save();
    user.posts.push(post);
    await user.save();
    res.status(201).json(post);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


router.get('/GetAllPosts', async (req, res) => {
    try {
        // Fetch all posts
        const posts = await Post.find();

        // Process each post to get user details
        const formattedPosts = await Promise.all(posts.map(async (post) => {
            try {
                // Fetch user details using the existing API endpoint
                const userDetails = await getUserDetails(post.userId);

                // Return formatted post with user details
                return {
                  postId:post.postId,
                  likeCount:post.likeCount,
                    postContent: post.postContent,
                    image: post.image,
                    userName: userDetails ? userDetails.name : null,
                    profileImage: userDetails ? userDetails.image : null,
                };
            } catch (error) {
                console.error(error);
                return {
                  postId:post.postId,
                  likeCount:post.likeCount,
                    postContent: post.postContent,
                    image: post.image,
                    userName: null,
                    profileImage: null,
                };
            }
        }));

        res.status(200).json(formattedPosts);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});


async function getUserDetails(userId) {
    try {
        console.log("id: " + userId);

        // Check if userId is undefined or null
        if (!userId) {
            throw new Error('User ID is undefined or null');
        }

        const user = await User.findOne({ userId: userId });

        if (!user) {
            throw new Error('User not found');
        }

        let userDetails;

        if (user.userType === 'patient') {
            userDetails = await Patient.findOne({ id: userId });
        } else if (user.userType === 'specialist') {
            userDetails = await Doctor.findOne({ id: userId });
        }

        if (!userDetails) {
            throw new Error('User details not found');
        }

        const { name, image } = userDetails;
        return { name, image };
    } catch (error) {
        console.error(error);
        throw error; // Rethrow the error to handle it in the calling function
    }
}



/*
router.get('/GetAllPosts', async (req, res) => {
    try {
      // Fetch all posts
      const posts = await Post.find();
  
      // Process each post to get user details
      const formattedPosts = await Promise.all(posts.map(async (post) => {
        try {
          // Fetch user details using the existing API endpoint
          const userDetails = await getUserDetails(post.userId);
  
          // Return formatted post with user details
          return {
            postContent: post.postContent,
            image: post.image,
            userName: userDetails ? userDetails.name : null,
            profileImage: userDetails ? userDetails.image : null,
          };
        } catch (error) {
          console.error(error);
          return {
            postContent: post.postContent,
            image: post.image,
            userName: null,
            profileImage: null,
          };
        }
      }));
  
      res.status(200).json(formattedPosts);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });
  */
  
  // ...
  
  
  
  

module.exports = router;