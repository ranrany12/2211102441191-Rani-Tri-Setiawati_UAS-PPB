import 'package:flutter/material.dart';
import 'package:news_app/services/global_methods.dart';
import 'package:reading_time/reading_time.dart';

class NewsModel with ChangeNotifier {
  String newsId,
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

  NewsModel({
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
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    String title = json['title'] ?? "";
    String description = json['description'] ?? "";
    String content = json['content'] ?? "";
    String dateToShow = GlobalMethods.formattedDateText(json['publishedAt']);

    return NewsModel(
      newsId: json['source']['id'] ?? "",
      sourceName: json['source']['name'] ?? "",
      authorName: json['author'] ?? "",
      title: json['title'] ?? "",
      content: json['content'] ?? "",
      dateToShow: dateToShow,
      description: json['description'] ?? "",
      publishedAt: json['publishedAt'] ?? "",
      readingTextTime: readingTime(title + description + content).msg,
      url: json['url'] ?? "",
      urlToImage: json['urlToImage'] ?? 'assets/images/empty_image.png',
    );
  }

  Map<String, dynamic> toJson(String userId) {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['newsId'] = newsId;
    data['sourceName'] = sourceName;
    data['authorName'] = authorName;
    data['title'] = title;
    data['content'] = content;
    data['dateToShow'] = dateToShow;
    data['description'] = description;
    data['publishedAt'] = publishedAt;
    data['readingTextTime'] = readingTextTime;
    data['url'] = url;
    data['urlToImage'] = urlToImage;
    data['userId'] = userId;

    return data;
  }

  static List<NewsModel> newsFromSnapShot(List newSnapShot) {
    return newSnapShot.map((json) {
      return NewsModel.fromJson(json);
    }).toList();
  }
}
