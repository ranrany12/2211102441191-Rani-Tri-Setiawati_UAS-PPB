import 'package:flutter/material.dart';
import 'package:news_app/consts/vars.dart';

class MyTabWidget extends StatelessWidget {
  const MyTabWidget({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  final String text;
  final void Function() onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: defaultButtonPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Theme.of(context).cardColor : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: isSelected ? 20 : 18,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
