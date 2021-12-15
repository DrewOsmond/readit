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

      newPosts.add(Post(
          title: currPost['title'],
          text: currPost['selftext'],
          upvotes: currPost['ups']));
    }

    posts.addAll(newPosts);
    return response;
  }

  Widget _renderPosts() {
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

// import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: _calculation, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Result: ${snapshot.data}'),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
