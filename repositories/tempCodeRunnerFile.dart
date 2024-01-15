import '../models/postsModels.dart';

List<PostModel> allPosts = [
  PostModel(
    postContent: "follow this tips for getting a healthy mind life",
    image:
        'https://media.istockphoto.com/id/1293388093/photo/two-men-exercising.jpg?s=2048x2048&w=is&k=20&c=8hUj3Sjas4nXGaYR298kgpQGi3DU3QJbmMf4-jYoRiA=',
    isFavourite: false,
    postUserModel: allUsers[2],
  ),
  PostModel(
    postContent: "follow this tips for getting a healthy mind life",
    image:
        'https://media.istockphoto.com/id/1039533792/photo/close-up-of-meditation-in-park-at-sunrise.jpg?s=2048x2048&w=is&k=20&c=5xp1m4oc64Mcl9HhhLlIGDE08oiUaFI02rqnlHd_jQo=',
    isFavourite: false,
    postUserModel: allUsers[1],
  ),
  PostModel(
    postContent: "here are some of questions to.. ",
    image:
        'https://media.istockphoto.com/id/1398880959/photo/question-mark-symbol-for-faq-information-problem-and-solution-concepts-quiz-test-survey.jpg?s=2048x2048&w=is&k=20&c=o4ou46Qu7rJak9M88vUl06jViRS26epQm_N9C2nwr4w=',
    isFavourite: true,
    postUserModel: allUsers[2],
  ),
  PostModel(
    postContent: "Now officially you can update ..",
    image:
        'https://media.istockphoto.com/id/1309867075/vector/computer-with-software-system-update-and-development.jpg?s=2048x2048&w=is&k=20&c=GgzOaT4ftJAY4RPZSOhRcW3d5eBQNSQMzLKasi7uRpA=',
    isFavourite: true,
    postUserModel: allUsers[3],
  ),
  PostModel(
    postContent: "what about joining ... ?",
    image:
        'https://media.istockphoto.com/id/962031404/photo/close-up-piece-of-white-jigsaw-puzzle-with-join-us-text-concept-of-a-business-challenge.jpg?s=1024x1024&w=is&k=20&c=xBF7t96MJ3FswxmjR4pkOtBlxs2GWzXtQOuqVxZ3Xqk=',
    isFavourite: false,
    postUserModel: allUsers[0],
  ),
  PostModel(
    postContent: "this photo has been taken on ... while ...",
    image:
        'https://images.unsplash.com/photo-1579684385127-1ef15d508118?auto=format&fit=crop&q=80&w=1780&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    isFavourite: true,
    postUserModel: allUsers[4],
  ),
];

List<PostUserModel> allUsers = [
  PostUserModel(
      userName: 'Enas',
      profileImage:
          'https://images.unsplash.com/photo-1534614971-6be99a7a3ffd?auto=format&fit=crop&q=80&w=1887&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
  PostUserModel(
    userName: 'Ali',
    profileImage:
        'https://images.unsplash.com/photo-1534614971-6be99a7a3ffd?auto=format&fit=crop&q=80&w=1887&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  PostUserModel(
    userName: 'Ahmad',
    profileImage:
        'https://media.istockphoto.com/id/156384937/photo/hispanic-doctor-reading-the-bible.jpg?s=2048x2048&w=is&k=20&c=iiTshtnCPLitkx9HOle_BIAVYPPXaRge8jLgCWBwJjk=',
  ),
  PostUserModel(
    userName: 'Tala',
    profileImage:
        'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  PostUserModel(
    userName: 'Abood',
    profileImage:
        'https://media.istockphoto.com/id/670397444/photo/studio-shot-of-young-happy-man-doctor-smiling-while-holding-clipboard-and-giving-thumb-up.jpg?s=2048x2048&w=is&k=20&c=4zEQld-XXLT1J_a3lVXNfxdhKXOGfQHRibb9kSR2fao=',
  ),
];
