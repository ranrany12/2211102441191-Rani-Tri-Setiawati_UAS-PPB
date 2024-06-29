import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/services/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:news_app/consts/global_colors.dart';
import 'package:news_app/consts/vars.dart';
import 'package:news_app/models/bookmark_model.dart';
import 'package:news_app/providers/bookmarks_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/services/global_methods.dart';
import 'package:news_app/services/utils.dart';
import 'package:news_app/utils/pallete.dart';
import 'package:news_app/widgets/my_text_content.dart';
import 'package:provider/provider.dart';
import 'package:reading_time/reading_time.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetailsScreen extends StatefulWidget {
  final MainModel? model;
  const NewsDetailsScreen({super.key, this.model});

  static const routeName = "/NewsDetailsScreen";

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  bool isInBookmark = false;
  String? publishedAt;
  dynamic currentBookmark;
  final _commentController = TextEditingController();
  var _commentClicked = false;
  var _collapseClicked = false;
  DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    //
    dbRef = FirebaseDatabase.instance.ref().child('comments');
    // widget.model.fetchCommentNews(newsmod)
  }

  @override
  void didChangeDependencies() {
    publishedAt = ModalRoute.of(context)?.settings.arguments as String;
    final List<BookmarksModel> bookmarksList =
        Provider.of<BookmarksProvider>(context).getBookmarksList;

    if (bookmarksList.isEmpty) {
      return;
    }

    currentBookmark = bookmarksList
        .where((bookmark) => bookmark.publishedAt == publishedAt)
        .toList();

    if (currentBookmark.isEmpty) {
      isInBookmark = false;
    } else {
      isInBookmark = true;
    }

    super.didChangeDependencies();
  }

  String getBookmarkKey(String publishedAt) {
    final bookmarksProvider = Provider.of<BookmarksProvider>(context);
    BookmarksModel bookmarksModel = bookmarksProvider.getBookmarksList
        .firstWhere((element) => element.publishedAt == publishedAt);

    String res = bookmarksModel.bookmarkKey;
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);
    final bookmarksProvider = Provider.of<BookmarksProvider>(context);

    final newsModel = newsProvider.findByDate(publishedAt: publishedAt!);
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'By ${newsModel.authorName}',
            style: TextStyle(
              color: color,
            ),
          ),
        ),
        body: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsModel.title,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat("dd-MM-yyyy")
                              .format(DateTime.parse(newsModel.publishedAt))
                              .toString(),
                          // GlobalMethods.formattedDateText(newsModel.publishedAt),
                          style: smallTextStyle,
                        ),
                        Text(
                          readingTime(newsModel.content).msg,
                          style: smallTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Image and Function Button
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Hero(
                            tag: newsModel.publishedAt,
                            child: FancyShimmerImage(
                              width: double.infinity,
                              boxFit: BoxFit.fill,
                              errorWidget:
                                  Image.asset('assets/images/empty_image.png'),
                              imageUrl: newsModel.urlToImage,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 16,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showModalBottomSheet(
                                      context, newsModel, model);
                                  // try {
                                  //   Share.share(newsModel.url);
                                  // } catch (err) {
                                  //   GlobalMethods.showErrorDialog(
                                  //     errorMessage: err.toString(),
                                  //     context: context,
                                  //   );
                                  // }
                                },
                                child: Card(
                                  elevation: 10,
                                  shape: const CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.add_comment_rounded,
                                      size: 24,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  try {
                                    Share.share(newsModel.url);
                                  } catch (err) {
                                    GlobalMethods.showErrorDialog(
                                      errorMessage: err.toString(),
                                      context: context,
                                    );
                                  }
                                },
                                child: Card(
                                  elevation: 10,
                                  shape: const CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.share,
                                      size: 24,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () async {
                                  if (isInBookmark) {
                                    await bookmarksProvider.deleteFromBookmark(
                                      context: context,
                                      bookmarkKey:
                                          currentBookmark[0].bookmarkKey,
                                    );
                                  } else {
                                    await bookmarksProvider.addToBookmark(
                                        context: context,
                                        newsModel: newsModel,
                                        userId: model.uid);
                                  }
                                  await bookmarksProvider.fetchBookmarks();
                                },
                                child: Card(
                                  elevation: 10,
                                  shape: const CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.bookmark,
                                      size: 24,
                                      color: isInBookmark
                                          ? Colors.yellow.shade700
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    const MyTextContent(
                      label: 'Deskripsi',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    // Description
                    MyTextContent(
                      label: newsModel.description,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(height: 16),
                    const MyTextContent(
                      label: 'Konten',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    // Contents
                    MyTextContent(
                      label: newsModel.content,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(height: 24),
                    ExpansionTile(
                      trailing: Icon(
                        !_collapseClicked
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: Utils(context).getColor,
                      ),
                      onExpansionChanged: (v) async {
                        setState(() {
                          _collapseClicked = v;
                        });
                        if (!_commentClicked) {
                          setState(() {
                            _commentClicked = true;
                          });
                          model.clearComments();
                          await model.fetchCommentNews(newsModel.title).then(
                              (_) => {
                                    model.commentList.sort((a, b) =>
                                        b['timestamp']
                                            .compareTo(a['timestamp']))
                                  });
                        }
                      },
                      title: Text(
                        !_commentClicked
                            ? "Lihat Komentar"
                            : model.commentList.isEmpty && _commentClicked
                                ? "Komentar (0)"
                                : "Komentar (${model.commentList.length})",
                        style: TextStyle(
                            fontSize: 16, color: Utils(context).getColor),
                      ),
                      children: model.commentList.isEmpty
                          ? []
                          : [
                              Column(
                                  children: model.commentList.map((e) {
                                return Container(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(left: 10),
                                    leading: Container(
                                      child: CircleAvatar(
                                        child: Text(
                                          e['name'].toString().substring(0, 1)
                                              .toUpperCase(),
                                          style: TextStyle(
                                              color: darkBackgroundColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${e['comment']}",
                                          style: TextStyle(
                                              color: Utils(context).getColor),
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(top: 5),
                                            child: const Divider(
                                              thickness: 0.5,
                                            ))
                                      ],
                                    ),
                                    title: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${e['name']}",
                                            style: TextStyle(
                                                color: Utils(context).getColor),
                                          ),
                                          Text(
                                            timeAgoCustom(
                                                DateTime.parse(e['timestamp'])),
                                            style: TextStyle(
                                                color: Utils(context).getColor,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList())
                            ],
                    ),
                  ],
                )),
          ],
        ),
      );
    });
  }

  void _showModalBottomSheet(context, NewsModel dataNews, MainModel model) {
    showModalBottomSheet(
        backgroundColor: ConstColors.whiteFontColor,
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        builder: (BuildContext bc) {
          return FractionallySizedBox(
            heightFactor:
                // model.user.roles == "STAFF" ||
                //         model.user.roles == "USER" ||
                //         model.user.roles == "OWNER" &&
                //             model.user.jumlahHariExpired! == 0
                //     ?
                0.6,
            // : 0.78,
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 7,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100)))),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.insert_comment_rounded,
                                    color: darkBackgroundColor),
                                const SizedBox(width: 5),
                                Text(
                                  "Tambahkan Komentar",
                                  style: TextStyle(
                                      color: darkBackgroundColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: _commentController,
                              // focusNode: _focusPassword,
                              // obscureText: true,
                              maxLines: null,
                              cursorColor: darkBackgroundColor,
                              style:
                                  const TextStyle(fontSize: 14, color: Colors.black),
                              // validator: (value) => Validator.validatePassword(
                              //   password: value,
                              // ),

                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      Map<String, dynamic> data = {
                                        'comment': _commentController.text,
                                        'name': model.nama,
                                        'timestamp': DateTime.now().toString(),
                                      };

                                      await dbRef?.ref
                                          .child(dataNews.title)
                                          .child(idGenerator())
                                          .set(data)
                                          .whenComplete(() async {
                                        Navigator.of(context).pop();
                                        _commentController.clear();
                                        //action
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 1),
                                            content: Text(
                                                'Komentar berhasil ditambahkan.'),
                                          ),
                                        );
                                        await model
                                            .fetchCommentNews(dataNews.title);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.send,
                                      color: darkBackgroundColor,
                                    )),
                                hintText: "tulis komentar anda...",
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: darkBackgroundColor,
                                        width: 2,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                        style: BorderStyle.solid)),
                                border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                        style: BorderStyle.solid)),
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            // Container(
                            //   height: 40,
                            //   width: 40,
                            //   padding: EdgeInsets.all(8),
                            //   decoration: BoxDecoration(
                            //       // color: ConstColors.primaryColor,
                            //       gradient: LinearGradient(
                            //         colors: [
                            //           Colors.red,
                            //           Colors.red.withOpacity(0.7),
                            //         ],
                            //         begin: Alignment.bottomCenter,
                            //         end: Alignment.topCenter,
                            //         // begin:
                            //         //     Alignment.topLeft, //begin of the gradient color
                            //         // end: Alignment
                            //         //     .bottomRight, //end of the gradient color
                            //         // stops: [0, 0.2, 0.5, 0.8]
                            //       ),
                            //       borderRadius: BorderRadius.circular(100)),
                            //   child: SvgPicture.asset(
                            //     'assets/icons/Web and Technology/alarm.svg',

                            //     // height: 10,
                            //     color: ConstColors.whiteFontColor,
                            //   ),
                            // ),
                            // Container(
                            //     padding: EdgeInsets.symmetric(
                            //         horizontal: 8, vertical: 4),
                            //     decoration: BoxDecoration(
                            //         color: Colors.grey[300],
                            //         borderRadius: BorderRadius.circular(5)),
                            //     child: Text('NEW',
                            //         style: pRegular14.copyWith(
                            //             fontSize: 11,
                            //             color: ConstColors.whiteFontColor))),
                            // SizedBox(height: 15),
                            // Container(
                            //     // padding: EdgeInsets.symmetric(
                            //     //     horizontal: 10, vertical: 4),
                            //     // decoration: BoxDecoration(
                            //     // color: Colors.grey[300],
                            //     // borderRadius: BorderRadius.circular(5)),
                            //     child: Text("Quelqu'un SONNE",
                            //         style: pSemiBold18.copyWith(
                            //             fontSize: 14,
                            //             color: ConstColors.textColor))),
                          ]),
                    ),

                    // SizedBox(
                    //     height: model.user.roles == "STAFF" ||
                    //             model.user.roles == "USER" ||
                    //             model.user.roles == "OWNER" &&
                    //                 model.user.jumlahHariExpired! == 0
                    //         ? 20
                    //         : 40),
                    // model.user.roles == "STAFF" ||
                    //         model.user.roles == "USER" ||
                    //         model.user.roles == "OWNER" &&
                    //             model.user.jumlahHariExpired! == 0
                    //     ? SizedBox()
                    //     : InkWell(
                    //         onTap: () async {
                    //           //

                    //           // if (_socket == null) {
                    //           //   SocketService.setUserName(model.user.name!);
                    //           //   model.connectAndListenChat(
                    //           //       model,
                    //           //       Activity(
                    //           //           usersId: data['databell']['id_staff'],
                    //           //           roomId: data['databell']['idRoomForChat'],
                    //           //           idRoomForChat: data['databell']['idRoomBell']));
                    //           //   //

                    //           // }

                    //           var body = {
                    //             'id_staff': data['databell']['id_staff'],
                    //             'message': "CHAT",
                    //             'idRoomBell': data['databell']['idRoomBell'],
                    //             'name': model.nama,
                    //             'idRoomForChat': data['databell']['idRoomForChat']
                    //           };
                    //           Navigator.of(context).pop();
                    //           sendFeedbackBell(body);
                    //           //
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (BuildContext context) => ChatPage(
                    //                       model,
                    //                       Activity(
                    //                           usersId: data['databell']
                    //                               ['id_staff'],
                    //                           roomId: data['databell']
                    //                               ['idRoomForChat'],
                    //                           idRoomForChat: data['databell']
                    //                               ['idRoomBell']))));
                    //         },
                    //         child: Container(
                    //           height: 48,
                    //           width: MediaQuery.of(context).size.width,
                    //           decoration: BoxDecoration(
                    //             border:
                    //                 Border.all(color: ConstColors.primaryColor),
                    //             color: ConstColors.whiteFontColor,
                    //             borderRadius: BorderRadius.circular(8),
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               SvgPicture.asset(
                    //                 'assets/icons/Communication/popup.svg',
                    //                 height: 30,
                    //                 // color: Colors.white54,
                    //                 color: ConstColors.primaryColor,
                    //               ),
                    //               SizedBox(width: 10),
                    //               Text(
                    //                 "ECRIRE AU VISITEUR",
                    //                 style: pSemiBold18.copyWith(
                    //                   fontSize: 16,
                    //                   color: ConstColors.primaryColor,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  String timeAgoCustom(DateTime d) {
    // <-- Custom method Time Show  (Display Example  ==> 'Today 7:00 PM')     // WhatsApp Time Show Status Shimila
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "y" : "y"}";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "m" : "m"}";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "w" : "w"}";
    }
    if (diff.inDays > 0) return DateFormat.E().add_jm().format(d);
    if (diff.inHours > 0) return "Today ${DateFormat('jm').format(d)}";
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "min" : "min"}";
    }
    return "now";
  }
}
