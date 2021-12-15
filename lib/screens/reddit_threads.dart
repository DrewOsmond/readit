import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './reddit_post.dart';
import '../models/posts.dart';

class RecentPosts extends StatefulWidget {
  final String subreddit;

  const RecentPosts({Key? key, required this.subreddit}) : super(key: key);

  @override
  _RecentPostsState createState() => _RecentPostsState(subreddit: subreddit);
}

class _RecentPostsState extends State<RecentPosts> {
  final List<Post> posts = [];
  final String subreddit;
  _RecentPostsState({required this.subreddit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subreddit),
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
        await http.get(Uri.parse("https://www.reddit.com/r/$subreddit.json"));

    final Map<String, dynamic> resData = jsonDecode(response.body);
    final List responsePosts = resData['data']['children'];
    final List<Post> newPosts = [];

    for (var post in responsePosts) {
      Map<String, dynamic> currPost = post['data'];
      newPosts.add(
        Post(
          title: currPost['title'],
          text: currPost['selftext'],
          upvotes: currPost['ups'],
          subreddit: currPost['subreddit'],
        ),
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

  void _redirectToPost(BuildContext context, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RedditPost(
          post: post,
        ),
      ),
    );
  }

  void _redirectToSubreddit(BuildContext context, String subreddit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecentPosts(
          subreddit: subreddit,
        ),
      ),
    );
  }

  Widget _renderTile(BuildContext context, Post post) {
    return Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("r/${post.subreddit}"),
              onTap: () => _redirectToSubreddit(context, post.subreddit),
            ),
            ListTile(
              title: Text(post.title),
              onTap: () => _redirectToPost(context, post),
              // onTap: Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => RedditPost(post: post))),
            ),
          ],
        ));
  }
}
