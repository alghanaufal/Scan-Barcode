import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

Widget createURLString(String text) {
  // Create a regular expression to match URL strings.
  RegExp urlRegExp = RegExp(
    r'^(https?|http)://[^\s/$.?#].[^\s]*$',
    caseSensitive: false,
    multiLine: false,
  );

  if (urlRegExp.hasMatch(text)) {
    return InkWell(
      onLongPress: () {
        Share.share(text, subject: 'Scan Result');
      },
      child: Text(
        text,
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        launchUrlString(text);
      },
    );
  } else {
    return InkWell(
      onLongPress: () async {
        Share.share(text, subject: 'Scan Result');
      },
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
