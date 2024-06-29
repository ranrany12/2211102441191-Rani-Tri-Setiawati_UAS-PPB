import 'package:flutter/material.dart';

class MyListTileWidget extends StatelessWidget {
  const MyListTileWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 18,
        ),
      ),
      onTap: onTap,
    );
  }
}
