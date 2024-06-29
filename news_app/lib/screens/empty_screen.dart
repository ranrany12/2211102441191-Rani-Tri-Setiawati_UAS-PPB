import 'package:flutter/material.dart';
import 'package:news_app/services/utils.dart';

class EmptyNewsScreen extends StatelessWidget {
  const EmptyNewsScreen({
    super.key,
    required this.imagePath,
    required this.text,
  });

  final String imagePath, text;

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).getColor;

    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(imagePath),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
