import 'package:flutter/material.dart';
import 'screens/reddit_threads.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.orange),
      home: RecentPosts(subreddit: "popular"),
    );
  }
}
