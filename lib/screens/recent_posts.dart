import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './reddit_post.dart';

class RecentPosts extends StatefulWidget {
  const RecentPosts({Key? key}) : super(key: key);

  @override
  _RecentPostsState createState() => _RecentPostsState();
}

class _RecentPostsState extends State<RecentPosts> {
  final List<Post> posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("recent posts"),
      ),
      body: FutureBuilder(
        future:
            _fetchPosts(), //http.get(Uri.parse("https://www.reddit.com/r/popular.json")),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "something went wrong!",
                ),
              );
            }

            return _renderPosts();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<http.Response> _fetchPosts() async {
    final http.Response response =
        await http.get(Uri.parse("https://www.reddit.com/r/popular.json"));

    final Map<String, dynamic> resData = jsonDecode(response.body);
    final List responsePosts = resData['data']['children'];
    final List<Post> newPosts = [];

    for (var post in responsePosts) {
      Map<String, dynamic> currPost = post['data'];

      newPosts.add(
        Post(
            title: currPost['title'],
            text: currPost['selftext'],
            upvotes: currPost['ups']),
      );
    }

    posts.addAll(newPosts);
    return response;
  }

  Widget _renderPosts() {
    return Scrollbar(
      child: ListView.separated(
        itemCount: posts.length,
        itemBuilder: (context, index) => _renderTile(context, posts[index]),
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.deepOrange,
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, Post post) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RedditPost(post: post)));
  }

  Widget _renderTile(BuildContext context, Post post) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: ListTile(
        title: Text(post.title),
        onTap: () => _handleTap(context, post),
        // onTap: Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => RedditPost(post: post))),
      ),
    );
  }
}

class Post {
  final String text;
  final String title;
  final int upvotes;

  Post({required this.text, required this.title, required this.upvotes});
}
