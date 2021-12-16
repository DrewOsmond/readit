import 'package:flutter/material.dart';
import 'package:readit/screens/reddit_threads.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("home"),
      ),
      body: const SearchBar(),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
      child: Row(
        children: [
          const Icon(Icons.search),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0)),
              onChanged: (String value) {
                setState(
                  () {
                    searchTerm = value;
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => _redirectToSubreddit(context, searchTerm),
            child: const Text("search"),
          )
          // ElevatedButton(
          //   onPressed: () => _redirectToSubreddit(context, searchTerm),
          //   child: const Text("search"),
          // ),
        ],
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
