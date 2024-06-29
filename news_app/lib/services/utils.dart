import 'package:flutter/material.dart';
import 'package:news_app/consts/vars.dart';
import 'package:news_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class Utils {
  BuildContext context;
  Utils(this.context);

  bool get getDarkTheme => Provider.of<ThemeProvider>(context).getDarkTheme;
  Color get getColor => getDarkTheme ? Colors.white : Colors.black;

  List<DropdownMenuItem<String>> get getDropDownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem<String>(
        value: SortByEnum.relevancy.name,
        child: const Text(
          'Sedang Viral',
        ),
      ),
      DropdownMenuItem<String>(
        value: SortByEnum.popularity.name,
        child: const Text('Terpopuler'),
      ),
      DropdownMenuItem<String>(
        value: SortByEnum.publishedAt.name,
        child: const Text('Terbaru'),
      ),
    ];
    return menuItems;
  }

  Size get getScreenSize => MediaQuery.of(context).size;

  Color get getBaseShimmerColor =>
      getDarkTheme ? Colors.grey.shade500 : Colors.grey.shade200;
  Color get getHighlightShimmerColor =>
      getDarkTheme ? Colors.grey.shade700 : Colors.grey.shade400;
  Color get getWidgetShimmerColor =>
      getDarkTheme ? Colors.grey.shade600 : Colors.grey.shade100;
}
