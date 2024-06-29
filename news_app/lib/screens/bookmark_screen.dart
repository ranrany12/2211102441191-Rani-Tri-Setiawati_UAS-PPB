import 'package:flutter/material.dart';
import 'package:news_app/consts/vars.dart';
import 'package:news_app/models/bookmark_model.dart';
import 'package:news_app/providers/bookmarks_provider.dart';
import 'package:news_app/screens/empty_screen.dart';
import 'package:news_app/widgets/my_articles_widget.dart';
import 'package:news_app/widgets/my_drawer.dart';
import 'package:news_app/widgets/my_loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Bookmarks',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        drawer: const MyDrawerWidget(),
        body: Column(
          children: [
            FutureBuilder<List<BookmarksModel>>(
              future: Provider.of<BookmarksProvider>(context, listen: false)
                  .fetchBookmarks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const MyLoadingWidget(
                    newsType: NewsType.allNews,
                  );
                } else if (snapshot.hasError) {
                  return Expanded(
                    child: EmptyNewsScreen(
                      imagePath: 'assets/images/no_news.png',
                      text: 'An error occurred ${snapshot.error}',
                    ),
                  );
                } else if (snapshot.data == null) {
                  return const Center(
                    child: EmptyNewsScreen(
                      imagePath: 'assets/images/no_news.png',
                      text: 'You didn\'t add anything yet to your bookmarks...',
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!
                        .where((element) => element.userId == model.uid)
                        .toList()
                        .length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: snapshot.data!
                            .where((element) => element.userId == model.uid)
                            .toList()[index],
                        child: const MyArticlesWidget(
                          isBookmark: true,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
