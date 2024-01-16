import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LikeProvider with ChangeNotifier {
  bool _isLiked = false;
  int _likeCount = 0;

  bool get isLiked => _isLiked;
  int get likeCount => _likeCount;

  void updateLikeStatus(bool isLiked, int likeCount) {
    _isLiked = isLiked;
    _likeCount = likeCount;
    notifyListeners();
  }
}
