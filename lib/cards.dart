import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10.0),
      child: Card(
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Image(
                image: NetworkImage(
                    "https://i0.wp.com/spacenews.com/wp-content/uploads/2023/07/hsc_20191119-33-scaled.jpg"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 15.0, bottom: 20.0, left: 10.0, right: 10.0),
              child: ListTile(
                title: Text(
                  "Ancient River Is Helping NASA's Perseverance Mars Rover Do Its Work",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
                ),
                subtitle: Text(
                    "The six-wheeled geologist is getting some assistance in its in search for diverse rock samples that could be brought to Earth for deeper investigation."),
              ),
            )
          ],
        ),
      ),
    );
  }
}
