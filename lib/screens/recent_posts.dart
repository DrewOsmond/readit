import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecentPosts extends StatefulWidget {
  const RecentPosts({Key? key}) : super(key: key);

  @override
  _RecentPostsState createState() => _RecentPostsState();
}

class _RecentPostsState extends State<RecentPosts> {
  final List<Post> posts = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          _fetchPosts(), //http.get(Uri.parse("https://www.reddit.com/r/popular.json")),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(
              child: Text(
                "something went wrong!",
              ),
            );
          }

          return _renderPosts(context);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<http.Response> _fetchPosts() async {
    final http.Response response =
        await http.get(Uri.parse("https://www.reddit.com/r/popular.json"));

    final Map<String, dynamic> resData = jsonDecode(response.body);
    final List responsePosts = resData['data']['children'];
    final List<Post> newPosts = [];

    for (var post in responsePosts) {
      print(post);
      Map<String, dynamic> currPost = post['data'];

      newPosts.add(Post(
          title: currPost['title'],
          text: currPost['selftext'],
          upvotes: currPost['ups']));
    }

    posts.addAll(newPosts);
    return response;
  }

  Widget _renderPosts(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) => _renderTile(context, posts[index]),
      ),
    );
  }
}

Widget _renderTile(BuildContext context, Post post) {
  return ListTile(title: Text(post.title));
}

class Post {
  final String text;
  final String title;
  final int upvotes;

  Post({required this.text, required this.title, required this.upvotes});
}
