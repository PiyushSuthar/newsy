import 'package:flutter/material.dart';

class SavedView extends StatelessWidget {
  const SavedView({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_add_outlined,
            size: 50,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Click On Bookmark Icon To Save News.",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
