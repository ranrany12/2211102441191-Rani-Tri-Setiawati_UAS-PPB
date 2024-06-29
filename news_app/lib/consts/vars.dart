import 'package:flutter/material.dart';

enum NewsType {
  topTrending,
  allNews,
}

enum SortByEnum {
  relevancy, // articles more closely related to queue come first
  popularity, // articles from popular sources and publishers come first
  publishedAt, // newest articles come first
}

const defaultButtonPadding = EdgeInsets.fromLTRB(16, 8, 16, 8);
const defaultSmallButtonPadding = EdgeInsets.all(8);

TextStyle smallTextStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

const List<String> searchKeywords = [
  'Football',
  'Flutter',
  'Python',
  'Weather',
  'Crypto',
  'Bitcoin',
  'Youtube',
  'Netflix',
  'Meta',
];
