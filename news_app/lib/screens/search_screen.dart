import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:news_app/consts/vars.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/empty_screen.dart';
import 'package:news_app/services/utils.dart';
import 'package:news_app/widgets/my_articles_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchController = TextEditingController();
  late FocusNode focusNode = FocusNode();
  List<NewsModel>? searchList = [];
  bool isSearching = false;

  @override
  void dispose() {
    if (mounted) {
      searchController.dispose();
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      focusNode.unfocus();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                    color: color,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.only(
                        left: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 1,
                          color: color,
                        ),
                      ),
                      child: TextField(
                        focusNode: focusNode,
                        controller: searchController,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.search,
                        onEditingComplete: () async {
                          searchList = await newsProvider.fetchNewsSearched(
                            query: searchController.text,
                          );

                          isSearching = true;
                          focusNode.unfocus();
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari berita...',
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          suffixIcon: IconButton(
                            onPressed: () {
                              searchController.clear();
                              isSearching = false;
                              searchList!.clear();
                              focusNode.unfocus();
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.close,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (searchList!.isEmpty && isSearching)
                const EmptyNewsScreen(
                  imagePath: 'assets/images/search.png',
                  text: 'Ops! No Results Found...',
                ),
              if (!isSearching && searchList!.isEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MasonryGridView.count(
                      itemCount: searchKeywords.length,
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 8,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            searchList = await newsProvider.fetchNewsSearched(
                              query: searchKeywords[index],
                            );
                            isSearching = true;
                            focusNode.unfocus();
                            setState(() {
                              searchController.text = searchKeywords[index];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: color,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: Text(
                                searchKeywords[index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (searchList != null && searchList!.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: searchList!.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: searchList![index],
                        child: const MyArticlesWidget(),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
