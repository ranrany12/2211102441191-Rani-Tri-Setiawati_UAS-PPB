import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/screens/blog_details.dart';
import 'package:news_app/screens/news_details_webview.dart';
import 'package:news_app/services/utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class TopTrendingWidget extends StatelessWidget {
  const TopTrendingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final newsModelProvider = Provider.of<NewsModel>(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          NewsDetailsScreen.routeName,
          arguments: newsModelProvider.publishedAt,
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FancyShimmerImage(
                width: double.infinity,
                height: size.height * 0.42,
                boxFit: BoxFit.fill,
                errorWidget: Image.asset('assets/images/empty_image.png'),
                imageUrl: newsModelProvider.urlToImage,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              newsModelProvider.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
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
                        size: 24,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Link',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ),
                SelectableText(
                  DateFormat("dd-MM-yyyy")
                      .format(DateTime.parse(newsModelProvider.dateToShow))
                      .toString(),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
