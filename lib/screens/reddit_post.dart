import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readit/controllers/images.dart';
import 'package:readit/models/comments.dart';
import '../models/posts.dart';

class RedditPost extends StatelessWidget {
  final String url;
  final Post post;

  RedditPost({Key? key, required this.url, required this.post})
      : super(key: key);

  final List comments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(post.title),
        ),
        body: Scrollbar(
          child: Column(
            children: <Widget>[
              Container(
                child: post.text.isNotEmpty
                    ? ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(post.text),
                      )
                    : null,
              ),
              Container(
                child: Images.renderImage(post.imgUrl),
              ),
              const Divider(),
              FutureBuilder(
                future: _fetchPost(),
                builder: _buildComments,
              ),
            ],
          ),
        ));
  }

  Future<http.Response> _fetchPost() async {
    final String link = url.substring(1, url.length - 1);
    final http.Response response =
        await http.get(Uri.parse("https://www.reddit.com/$link.json"));
    final List<dynamic> resData = jsonDecode(response.body);
    final List<dynamic> resComments = resData[1]['data']['children'];

    final List<Comment> newComments = [];
    for (Map comment in resComments) {
      Map commentData = comment['data'];

      if (commentData.containsKey('body')) {
        newComments.add(
          Comment(body: commentData['body'], author: commentData['author']),
        );
      }
    }

    comments.addAll(newComments);

    return response;
  }

  Widget _buildComments(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return const Center(
          child: Text("something went wrong!"),
        );
      }

      return _renderComments();
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _renderComments() {
    return Expanded(
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) =>
            _renderComment(context, comments[index]),
      ),
    );
  }

  Widget _renderComment(BuildContext context, Comment comment) {
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 0.0),
          title: Text(comment.author),
        ),
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 8.0),
          title: Text(comment.body),
        ),
        const Divider(
          color: Colors.deepOrange,
        ),
      ],
    );
  }
}
