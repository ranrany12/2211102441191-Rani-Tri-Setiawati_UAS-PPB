// import 'package:kasirapp/services/user_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';
// import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'package:dio/dio.dart';
// import '../models/bar_chart_model.dart';

mixin Services on Model {
  // List<Map> _transactionList = [];
  // List<Map> get transactionList => _transactionList;

  final List<Map> _commentList = [];
  List<Map> get commentList => _commentList;

  // List<BarChartModel> _orderHistoryList = [];
  // List<BarChartModel> get orderHistoryList => _orderHistoryList;

  // List<BarChartModel> _filterHistoryByDates = [];
  // List<BarChartModel> get filterHistoryByDates => _filterHistoryByDates;

  // List<BarChartModel> filterStatistic7Day() {
  //   var now = new DateTime.now();
  //   var now_1w = now.subtract(Duration(days: 7));
  //   //
  //   var filteringHistoryOrders = _orderHistoryList
  //       .where((element) => now_1w.isBefore(element.timestamp))
  //       .toList();
  //   //
  //   _filterHistoryByDates = filteringHistoryOrders;
  //   notifyListeners();
  //   //
  //   return _orderHistoryList;
  // }

  // List<BarChartModel> filterStatistic1Month() {
  //   var now = new DateTime.now();
  //   var now_1m = new DateTime(now.year, now.month - 1, now.day);
  //   var filteringHistoryOrders = _orderHistoryList
  //       .where((element) => now_1m.isBefore(element.timestamp))
  //       .toList();
  //   //
  //   _filterHistoryByDates = filteringHistoryOrders;
  //   notifyListeners();
  //   //
  //   return _orderHistoryList;
  // }

  // Future<dynamic> fetchTransaction(String uid) async {
  //   var _productData;

  //   var dio = Dio();
  //   dio.options
  //     ..baseUrl = 'https://skripsi-eab46-default-rtdb.firebaseio.com/'
  //     ..connectTimeout = 10000 //5s
  //     ..receiveTimeout = 10000
  //     ..validateStatus = (int? status) {
  //       return status! > 0;
  //     }
  //     ..headers = {
  //       HttpHeaders.userAgentHeader: 'dio',
  //     };

  //   try {
  //     var responseData = await dio.get(
  //       'transaksi.json',
  //       // data: _data,
  //       options: Options(
  //         contentType: Headers.formUrlEncodedContentType,
  //       ),
  //     );

  //     _productData = responseData.data[uid];

  //     print("RESPONSE GET PRODUCTS: ${responseData.data[uid]}");
  //     _transactionList.clear();
  //     if (responseData.data[uid] != null) {
  //       responseData.data[uid].forEach((prodId, prodData) {
  //         _transactionList.add(prodData);
  //       });
  //     }
  //     print(_transactionList.length);

  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }

  //   return _productData;
  // }

  Future<dynamic> fetchCommentNews(String newsId) async {
    var commentData;

    // _isLoadingProduct = true;
    // notifyListeners();

    var dio = Dio();
    dio.options
      ..baseUrl = 'https://newsapp-17e74-default-rtdb.firebaseio.com/'
      ..connectTimeout = 10000 //5s
      ..receiveTimeout = 10000
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
      };

    try {
      var responseData = await dio.get(
        'comments.json',
        // data: _data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("RESPONSE GET COMMENTS: ${responseData.data[newsId]}");
      _commentList.clear();
      responseData.data[newsId].forEach((prodId, commentsData) {
        _commentList.add(commentsData);
        notifyListeners();
      });

      print(_commentList.length);

      notifyListeners();
    } catch (e) {
      print(e);
    }

    return commentData;
  }

  // Future<dynamic> fetchHistoriOrder(String uid) async {
  //   var _historyData;

  //   // _isLoadingProduct = true;
  //   // notifyListeners();

  //   var dio = Dio();
  //   dio.options
  //     ..baseUrl = 'https://skripsi-eab46-default-rtdb.firebaseio.com/'
  //     ..connectTimeout = 10000 //5s
  //     ..receiveTimeout = 10000
  //     ..validateStatus = (int? status) {
  //       return status! > 0;
  //     }
  //     ..headers = {
  //       HttpHeaders.userAgentHeader: 'dio',
  //     };

  //   try {
  //     var responseData = await dio.get(
  //       'history.json',
  //       // data: _data,
  //       options: Options(
  //         contentType: Headers.formUrlEncodedContentType,
  //       ),
  //     );

  //     print("RESPONSE GET HISTORY: ${responseData.data[uid]}");
  //     _orderHistoryList.clear();
  //     responseData.data[uid].forEach((prodId, prodData) {
  //       print(prodData["orderId"].toString().substring(5, 7));
  //       _orderHistoryList.add(BarChartModel(
  //         timestamp: DateTime.parse(prodData["orderId"]),
  //         year: DateFormat("d/MM", 'id_ID')
  //             .format(DateTime.parse(prodData["orderId"]))
  //             .toString(),
  //         financial: prodData["total"],
  //         color: charts.ColorUtil.fromDartColor(
  //             prodData["orderId"].toString().substring(5, 7) == "10"
  //                 ? Colors.blue
  //                 : prodData["orderId"].toString().substring(5, 7) == "11"
  //                     ? Colors.red
  //                     : prodData["orderId"].toString().substring(5, 7) == "12"
  //                         ? Colors.yellow
  //                         : Colors.blueGrey),
  //       ));
  //       //
  //       notifyListeners();
  //       //
  //       filterStatistic7Day();
  //     });

  //     print("orderHistoryList: ${_orderHistoryList.length}");
  //   } catch (e) {
  //     print(e);
  //   }

  //   return _historyData;
  // }

  // void clearData() {
  //   _historyList.clear();
  //   _orderHistoryList.clear();
  //   _transactionList.clear();
  //   notifyListeners();
  // }

  void clearComments() {
    _commentList.clear();
    notifyListeners();
  }
}
