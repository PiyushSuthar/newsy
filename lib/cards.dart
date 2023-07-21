import 'package:flutter/material.dart';
import 'dart:convert' show utf8;

import 'package:news_app/api/spaceflight.dart';
import 'package:news_app/handler/storage.dart';
import 'package:provider/provider.dart';
// import 'package:news_app/handler/storage.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class NewsCard extends StatefulWidget {
  const NewsCard(
      {super.key,
      // required this.title,
      // required this.subtitle,
      // required this.image,
      required this.news,
      this.showBookMark = false});

  final Result news;
  final bool showBookMark;

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  // final String title;

  late bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _getSaved();
  }

  Future<void> _getSaved() async {
    _isSaved = await isSaved(widget.news.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shadowColor: Colors.black.withOpacity(0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: InkWell(
          onTap: () {
            _launchURL(context, widget.news.url);
          },
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          child: Stack(
            children: <Widget>[
              Column(children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  child: Image.network(
                    widget.news.imageUrl,
                    fit: BoxFit.cover,
                    height: 200.0,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/images/scene.jpg");
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 20.0, left: 10.0, right: 10.0),
                  child: ListTile(
                    title: Text(
                      utf8.decode(widget.news.title.codeUnits),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        utf8.decode(widget.news.summary.codeUnits),
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
              ]),
              SaveIcon(
                news: widget.news,
                showBookmark: !_isSaved,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          // animation: CustomTabsAnimation.slideIn(),
          // // or user defined animation.
          // animation: const CustomTabsAnimation(
          //   startEnter: 'slide_up',
          //   startExit: 'android:anim/fade_out',
          //   endEnter: 'android:anim/fade_in',
          //   endExit: 'slide_down',
          // ),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}

class SaveIcon extends StatelessWidget {
  const SaveIcon({
    super.key,
    required this.news,
    required this.showBookmark,
  });
  final bool showBookmark;

  final Result news;
  @override
  Widget build(BuildContext context) {
    return Consumer<MainStore>(
      builder: (context, value, child) {
        return Positioned(
          top: 0,
          right: 10,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              icon: Icon(
                showBookmark ? Icons.bookmark_add_outlined : Icons.bookmark_add,
                size: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.background)),
              onPressed: () {
                // saveData(news.id.toString(), news);
                if (showBookmark) {
                  value.addNews(news);
                } else {
                  value.removeNews(news);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
