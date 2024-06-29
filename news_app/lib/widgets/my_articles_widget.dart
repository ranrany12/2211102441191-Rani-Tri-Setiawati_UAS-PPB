import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:intl/intl.dart';
import 'package:news_app/consts/vars.dart';
import 'package:news_app/models/bookmark_model.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/screens/blog_details.dart';
import 'package:news_app/screens/news_details_webview.dart';
import 'package:news_app/services/utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MyArticlesWidget extends StatelessWidget {
  const MyArticlesWidget({
    super.key,
    this.isBookmark = false,
  });

  final bool isBookmark;

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    dynamic newsModelProvider = isBookmark
        ? Provider.of<BookmarksModel>(context)
        : Provider.of<NewsModel>(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          NewsDetailsScreen.routeName,
          arguments: newsModelProvider.publishedAt,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 8,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.only(
          left: 8.0,
          top: 8.0,
          bottom: 8.0,
          right: 12.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Hero(
                tag: newsModelProvider.publishedAt,
                child: FancyShimmerImage(
                  width: size.width * 0.28,
                  height: size.height * 0.14,
                  boxFit: BoxFit.fill,
                  imageUrl: newsModelProvider.urlToImage,
                  errorWidget: Image.asset('assets/images/empty_image.png'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsModelProvider.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    style: smallTextStyle,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(newsModelProvider.readingTextTime),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageTransition(
                              child: NewsDetailsWebviewScreen(
                                url: newsModelProvider.url,
                              ),
                              type: PageTransitionType.rightToLeft,
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.link,
                              color: Colors.blue,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Link',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(DateFormat("dd-MM-yyyy")
                          .format(DateTime.parse(newsModelProvider.dateToShow))
                          .toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
