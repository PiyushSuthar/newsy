import 'dart:convert';

import 'package:http/http.dart' as http;

// {"count": 17219,
// "next": "https://api.spaceflightnewsapi.net/v4/articles/?_limit=10&_start=0&limit=10&offset=10",
// "previous": null, "result": [{
//             "id": 20044,
//             "title": "Insurers brace for ViaSat-3 claim",
//             "url": "https://spacenews.com/insurers-brace-for-viasat-3-claim/",
//             "image_url": "https://i0.wp.com/spacenews.com/wp-content/uploads/2023/07/Viasat-3-reflector-_Screenshot-2023-07-13-at-10.03.05-AM.png",
//             "news_site": "SpaceNews",
//             "summary": "The potential failure of a Viasat broadband satellite could result in a massive claim and a “huge hit” for the space insurance sector, one insurer warns.",
//             "published_at": "2023-07-19T09:47:22Z",
//             "updated_at": "2023-07-19T10:35:34.111000Z",
//             "featured": false,
//             "launches": [
//                 {
//                     "launch_id": "8b1067dd-81c6-4bc3-b0f1-45f78963716f",
//                     "provider": "Launch Library 2"
//                 }
//             ],
//             "events": [{
//    "event_id": 10,
// "provider": "hehe"
// }]
//         }]}

class NewsApi {
  static Future<List<Result>> getNews() async {
    final response = await http
        .get(Uri.parse('https://api.spaceflightnewsapi.net/v4/articles'));
    if (response.statusCode == 200) {
      // final List<News> news = [];
      // final List<dynamic> json = response.body as List<News>;
      // for (var element in json) {
      //   news.add(News.fromJson(element));
      // }

      return welcomeFromJson(response.body).result;
    } else {
      throw Exception('Failed to load news');
    }
  }
}

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  int count;
  String next;
  dynamic previous;
  List<Result> result;

  Welcome({
    required this.count,
    required this.next,
    this.previous,
    required this.result,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        result:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  int id;
  String title;
  String url;
  String imageUrl;
  String newsSite;
  String summary;
  DateTime publishedAt;
  DateTime updatedAt;
  bool featured;
  List<Launch> launches;
  List<Event> events;

  Result({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
    required this.updatedAt,
    required this.featured,
    required this.launches,
    required this.events,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        url: json["url"],
        imageUrl: json["image_url"],
        newsSite: json["news_site"],
        summary: json["summary"],
        publishedAt: DateTime.parse(json["published_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        featured: json["featured"],
        launches:
            List<Launch>.from(json["launches"].map((x) => Launch.fromJson(x))),
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "url": url,
        "image_url": imageUrl,
        "news_site": newsSite,
        "summary": summary,
        "published_at": publishedAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "featured": featured,
        "launches": List<dynamic>.from(launches.map((x) => x.toJson())),
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
      };
}

class Event {
  int eventId;
  String provider;

  Event({
    required this.eventId,
    required this.provider,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        eventId: json["event_id"],
        provider: json["provider"],
      );

  Map<String, dynamic> toJson() => {
        "event_id": eventId,
        "provider": provider,
      };
}

class Launch {
  String launchId;
  String provider;

  Launch({
    required this.launchId,
    required this.provider,
  });

  factory Launch.fromJson(Map<String, dynamic> json) => Launch(
        launchId: json["launch_id"],
        provider: json["provider"],
      );

  Map<String, dynamic> toJson() => {
        "launch_id": launchId,
        "provider": provider,
      };
}
