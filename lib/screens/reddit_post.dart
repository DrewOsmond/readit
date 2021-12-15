import 'package:flutter/material.dart';
import 'package:readit/screens/recent_posts.dart';

class RedditPost extends StatelessWidget {
  final Post post;

  const RedditPost({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Center(
        child: Text(post.text),
      ),
    );
  }
}
