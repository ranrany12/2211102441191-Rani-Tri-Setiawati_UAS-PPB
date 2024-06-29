import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/empty_screen.dart';
import 'package:news_app/widgets/my_loading_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:news_app/consts/global_colors.dart';
import 'package:news_app/consts/vars.dart';
import 'package:news_app/screens/search_screen.dart';
import 'package:news_app/services/utils.dart';
import 'package:news_app/widgets/my_articles_widget.dart';
import 'package:news_app/widgets/my_drawer.dart';
import 'package:news_app/widgets/my_pagination_button.dart';
import 'package:news_app/widgets/my_tabs.dart';
import 'package:news_app/widgets/my_top_trending_widget.dart';
import 'package:provider/provider.dart';
// import 'package:news_app/widgets/my_loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var newsType = NewsType.allNews;
  int currentPageIndex = 0;
  String currentSortBy = SortByEnum.relevancy.name;

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const SearchScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
        title: const Text(
          'ViralNewz',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      drawer: const MyDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // tabs bar
            Row(
              children: [
                MyTabWidget(
                  text: 'Semua Berita',
                  onTap: () {
                    if (newsType == NewsType.allNews) {
                      return;
                    } else {
                      setState(() {
                        newsType = NewsType.allNews;
                      });
                    }
                  },
                  isSelected: newsType == NewsType.allNews,
                ),
                const SizedBox(width: 8),
                MyTabWidget(
                  text: 'Trending',
                  onTap: () {
                    if (newsType == NewsType.topTrending) {
                      return;
                    } else {
                      setState(() {
                        newsType = NewsType.topTrending;
                      });
                    }
                  },
                  isSelected: newsType == NewsType.topTrending,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // pagination bar
            newsType == NewsType.allNews
                ? SizedBox(
                    height: kBottomNavigationBarHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyPaginationButtonWidget(
                          text: 'Prev',
                          onPressed: () {
                            if (currentPageIndex == 0) return;
                            setState(() {
                              currentPageIndex--;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 12,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                  vertical: 8.0,
                                ),
                                child: Material(
                                  borderRadius: BorderRadius.circular(12),
                                  color: currentPageIndex == index
                                      ? Utils(context).getDarkTheme
                                          ? darkButtonColor
                                          : lightButtonColor
                                      : Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        currentPageIndex = index;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Center(
                                        child: Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: currentPageIndex == index
                                                ? (Utils(context).getDarkTheme
                                                    ? Theme.of(context)
                                                        .scaffoldBackgroundColor
                                                    : Colors.white)
                                                : Utils(context).getColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        MyPaginationButtonWidget(
                          text: 'Next',
                          onPressed: () {
                            setState(() {
                              currentPageIndex++;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: Colors.deepPurple,
                  ),
            const SizedBox(height: 8),

            // dropdown selection
            newsType == NewsType.allNews
                ? Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(12),
                          underline: const SizedBox(),
                          dropdownColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          value: currentSortBy,
                          items: Utils(context).getDropDownItems,
                          onChanged: (selectedItem) {
                            setState(() {
                              currentSortBy = selectedItem!;
                            });
                          },
                        ),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 8),

            // list articles
            FutureBuilder<List<NewsModel>>(
              future: newsType == NewsType.allNews
                  ? newsProvider.fetchAllNews(
                      pageIndex: currentPageIndex + 1,
                      sortBy: currentSortBy,
                    )
                  : newsProvider.fetchTopHeadlinesNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return MyLoadingWidget(
                    newsType: newsType,
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
                      text: 'No News...',
                    ),
                  );
                }
                return newsType == NewsType.allNews
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider.value(
                              value: snapshot.data![index],
                              child: const MyArticlesWidget(),
                            );
                          },
                        ),
                      )
                    : SizedBox(
                        height: Utils(context).getScreenSize.height * 0.62,
                        child: Swiper(
                          itemCount: 7,
                          layout: SwiperLayout.STACK,
                          itemWidth: Utils(context).getScreenSize.width * 0.9,
                          itemBuilder: (context, index) =>
                              ChangeNotifierProvider.value(
                            value: snapshot.data![index],
                            child: const TopTrendingWidget(),
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
