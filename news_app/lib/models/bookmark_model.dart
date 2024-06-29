import 'package:flutter/material.dart';

class BookmarksModel with ChangeNotifier {
  String bookmarkKey,
      newsId,
      sourceName,
      authorName,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      dateToShow,
      content,
      readingTextTime;
  String? userId;

  BookmarksModel(
      {required this.bookmarkKey,
      required this.newsId,
      required this.sourceName,
      required this.authorName,
      required this.title,
      required this.content,
      required this.dateToShow,
      required this.description,
      required this.publishedAt,
      required this.readingTextTime,
      required this.url,
      required this.urlToImage,
      this.userId});

  factory BookmarksModel.fromJson({
    required dynamic json,
    required String bookmarkKey,
  }) {
    return BookmarksModel(
      bookmarkKey: bookmarkKey,
      newsId: json['newsId'] ?? "",
      sourceName: json['sourceName'] ?? "",
      authorName: json['authorName'] ?? "",
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      url: json['url'] ?? "",
      urlToImage: json['urlToImage'] ?? 'assets/images/empty_image.png',
      publishedAt: json['publishedAt'] ?? "",
      dateToShow: json['dateToShow'],
      content: json['content'] ?? "",
      readingTextTime: json['readingTextTime'],
      userId: json['userId'] ?? "",
    );
  }

  static List<BookmarksModel> bookmarksFromSnapshot({
    required List allKeys,
    required dynamic json,
  }) {
    return allKeys.map(
      (key) {
        return BookmarksModel.fromJson(
          json: json[key],
          bookmarkKey: key,
        );
      },
    ).toList();
  }
}
