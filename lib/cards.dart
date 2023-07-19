import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        borderOnForeground: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              child: Image(
                image: NetworkImage(image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 20.0, left: 10.0, right: 10.0),
              child: ListTile(
                title: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 17.0),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    subtitle,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
