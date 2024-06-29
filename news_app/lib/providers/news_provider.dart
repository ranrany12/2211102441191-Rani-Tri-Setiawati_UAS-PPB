import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/services/news_api.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsModel> newsList = [];

  List<NewsModel> get getNewsList => newsList;

  Future<List<NewsModel>> fetchAllNews({
    required int pageIndex,
    required String sortBy,
  }) async {
    newsList = await NewsApiServices.getAllNews(
      page: pageIndex,
      sortBy: sortBy,
    );
    return newsList;
  }

  Future<List<NewsModel>> fetchTopHeadlinesNews() async {
    newsList = await NewsApiServices.getTopHeadlines();
    return newsList;
  }

  Future<List<NewsModel>> fetchNewsSearched({required String query}) async {
    newsList = await NewsApiServices.getNewsSearched(query: query);
    return newsList;
  }

  NewsModel findByDate({required String? publishedAt}) {
    return newsList.firstWhere((news) => news.publishedAt == publishedAt);
  }
}
