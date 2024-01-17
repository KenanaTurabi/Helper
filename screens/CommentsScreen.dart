import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/comment.dart';
import 'package:flutter_application_1/widgets/CustomAppBar.dart';

class CommentsScreen extends StatefulWidget {
  final List<CommentModel> comments;

  CommentsScreen(this.comments);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  bool isDark = false;
  void updateState(bool newValue) {
    setState(() {
      isDark = newValue;
      print(isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomeAppBar customeAppBar = new CustomeAppBar(isDark, updateState);

    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: customeAppBar,
        ),
        body: ListView.builder(
          itemCount: widget.comments.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.comments[index].commentOwnerImage ??
                          "", // Provide the image URL
                    ),
                    radius: 20,
                  ),
                  title: Text(widget.comments[index].commentOwnerName),
                  subtitle: Text(widget.comments[index].content),
                ),
                Divider(
                  thickness: 0.3,
                  color: Colors.grey,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
