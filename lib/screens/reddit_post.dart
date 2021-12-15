import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readit/controllers/images.dart';
import 'package:readit/screens/reddit_threads.dart';
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
                builder: _buildPost,
              ),
            ],
          ),
        ));
  }

  Future<http.Response> _fetchPost() async {
    final http.Response response =
        await http.get(Uri.parse("https://www.reddit.com/r"));
    final Map<String, dynamic> resData = jsonDecode(response.body);

    return response;
  }

  Widget _buildPost(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return const Center(
          child: Text("something went wrong!"),
        );
      }

      return _renderPost();
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _renderPost() {
    return Container();
  }
}
