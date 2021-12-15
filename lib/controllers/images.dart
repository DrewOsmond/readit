import 'package:flutter/material.dart';

class Images {
  static renderImage(String url) {
    if (url.endsWith(".jpg") ||
        url.endsWith(".jpg") ||
        url.contains("https://gfycat.com")) {
      print(url);
      return Image.network(url);
    }

    return null;
  }
}
