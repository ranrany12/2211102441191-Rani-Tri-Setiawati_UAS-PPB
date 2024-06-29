import 'package:flutter/material.dart';
import 'package:news_app/consts/global_colors.dart';
import 'package:news_app/consts/vars.dart';
import 'package:news_app/services/utils.dart';

class MyPaginationButtonWidget extends StatelessWidget {
  const MyPaginationButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Utils(context).getDarkTheme ? darkButtonColor : lightButtonColor,
        padding: defaultButtonPadding,
        foregroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
