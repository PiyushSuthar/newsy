import 'package:flutter/material.dart';
import 'dart:convert' show utf8;

import 'package:news_app/api/spaceflight.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    // required this.title,
    // required this.subtitle,
    // required this.image,
    required this.news,
  });

  final Result news;
  // final String title;
  // final String subtitle;
  // final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shadowColor: Colors.black.withOpacity(0),
        // borderOnForeground: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Stack(
          children: <Widget>[
            Column(children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/scene.jpg",
                    image: news.imageUrl),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 20.0, left: 10.0, right: 10.0),
                child: ListTile(
                  title: Text(
                    utf8.decode(news.title.codeUnits),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 17.0),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      utf8.decode(news.summary.codeUnits),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                ),
              ),
            ]),
            const SaveIcon(),
          ],
        ),
      ),
    );
  }
}

class SaveIcon extends StatelessWidget {
  const SaveIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 10,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: IconButton(
          icon: Icon(
            Icons.bookmark_add_outlined,
            size: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.background)),
          onPressed: () {},
        ),
      ),
    );
  }
}
