import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter/material.dart';
class Publicos{
  openBrowserTab(String ur) async {
    await FlutterWebBrowser.openWebPage(
        url: ur, androidToolbarColor: const Color(0xFF1B396A));
  }

  launchURL(String value) async {
    final url = 'tel:$value';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  sendMail(String value) async {
    // Android and iOS
    String uri = 'mailto:$value';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }


}