class Post {
  final String text;
  final String title;
  final int upvotes;
  final String subreddit;
  final String url;
// url_overridden_by_dest
  Post(
      {required this.text,
      required this.title,
      required this.upvotes,
      required this.subreddit,
      required this.url});
}
