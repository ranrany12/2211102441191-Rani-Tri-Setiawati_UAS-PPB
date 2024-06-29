import 'package:flutter/material.dart';

class MyTextContent extends StatelessWidget {
  const MyTextContent({
    super.key,
    required this.label,
    required this.fontSize,
    required this.fontWeight,
  });

  final String label;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      label, 
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
