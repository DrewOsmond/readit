import 'package:flutter/material.dart';

class Images {
  static renderImage(String url) {
    if (url.endsWith(".jpg") || url.endsWith(".jpg")) {
      print(url);
      return Image.network(url);
    }

    // if (url.contains("https://gfycat.com")) {
    //   return Image.network(url + "-mobile.mp4");
    // }

    return null;
  }
}
