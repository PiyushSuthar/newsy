import 'package:flutter/material.dart';
import 'package:news_app/cards.dart';
import 'package:news_app/handler/storage.dart';
import 'package:provider/provider.dart';

class SavedView extends StatefulWidget {
  const SavedView({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainStore>(
      builder: (context, value, child) {
        if (value.news.result.isEmpty) {
          return noSaved(context);
        }
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10.0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                tileColor: ElevationOverlay.applySurfaceTint(
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surfaceTint,
                    3),
                title: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Saved",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Are you sure?"),
                          content: const Text(
                              "This will delete all of the saved news which you bookmarked."),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('Delete'),
                              onPressed: () {
                                clearData();
                                value.getLocalStorage();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ),
            ...value.news.result
                .map((e) => NewsCard(
                      news: e,
                      showBookMark: false,
                    ))
                .toList()
          ],
        );
      },
    );
  }

  Center noSaved(BuildContext context) {
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
