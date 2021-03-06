import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './reddit_post.dart';
import '../models/posts.dart';
import '../controllers/images.dart';

class SubReddit extends StatelessWidget {
  final List<Post> posts = [];
  final String subreddit;

  SubReddit({Key? key, required this.subreddit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("r/$subreddit"),
      ),
      body: FutureBuilder(
        future: _fetchPosts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "something went wrong!",
                ),
              );
            }

            return _buildPosts();
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

    final Map<String, dynamic> resData = await jsonDecode(response.body);
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
          imgUrl: currPost['url'],
          postLink: currPost['permalink'],
          // img: currPost['url_overridden_by_dest'],
        ),
      );
    }

    posts.addAll(newPosts);
    return response;
  }

  Widget _buildPosts() {
    return Scrollbar(
      child: ListView.separated(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, index) =>
            _Post(context: context, post: posts[index], subreddit: subreddit),
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.deepOrange,
        ),
      ),
    );
  }
}

class _Post extends StatelessWidget {
  final Post post;
  final BuildContext context;
  final String subreddit;

  const _Post(
      {Key? key,
      required this.post,
      required this.context,
      required this.subreddit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("r/${post.subreddit}"),
            onTap: () => post.subreddit != subreddit
                ? _redirectToSubreddit(context, post.subreddit)
                : null,
          ),
          ListTile(
            title: Text(post.title),
            onTap: () => _redirectToPost(context, post),
            // onTap: Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => RedditPost(post: post))),
          ),
          GestureDetector(
            onTap: () => _redirectToPost(context, post),
            child: Container(
              child: Images.renderImage(post.imgUrl),
            ),
          ),
        ],
      ),
    );
    // return Container();
  }

  void _redirectToPost(BuildContext context, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RedditPost(
          url: post.postLink,
          post: post,
        ),
      ),
    );
  }

  void _redirectToSubreddit(BuildContext context, String subreddit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubReddit(
          subreddit: subreddit,
        ),
      ),
    );
  }
}
