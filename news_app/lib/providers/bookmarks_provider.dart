import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:news_app/consts/api_consts.dart';
import 'package:news_app/models/bookmark_model.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/news_model.dart';
import 'package:news_app/services/news_api.dart';

class BookmarksProvider with ChangeNotifier {
  List<BookmarksModel> bookmarksList = [];

  List<BookmarksModel> get getBookmarksList => bookmarksList;

  Future<void> addToBookmark(
      {required BuildContext context,
      required NewsModel newsModel,
      String? userId}) async {
    try {
      Uri uri = Uri.https(
        FIREBASE_URL,
        'bookmarks.json',
      );

      var response = await http.post(
        uri,
        body: jsonEncode(
          newsModel.toJson(userId!),
        ),
      );
      notifyListeners();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Berhasil ditambahkan ke bookmarks.'),
          ),
        );
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> deleteFromBookmark(
      {required BuildContext context, required String bookmarkKey}) async {
    try {
      Uri uri = Uri.https(
        FIREBASE_URL,
        'bookmarks/$bookmarkKey.json',
      );

      var response = await http.delete(uri);
      notifyListeners();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Berhasil dihapus dari Bookmark.'),
          ),
        );
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<List<BookmarksModel>> fetchBookmarks() async {
    bookmarksList = await NewsApiServices.getBookmarks();
    notifyListeners();
    return bookmarksList;
  }
}
