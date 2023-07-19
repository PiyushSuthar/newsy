import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:news_app/cards.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: "Newsy",
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightDynamic,
              primarySwatch: Colors.blue),
          darkTheme: ThemeData(useMaterial3: true, colorScheme: darkDynamic),
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // change brightnes of the background color
        appBar: AppBar(
          title: const Text(
            "Newsy",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          children: const [NewsCard()],
        ));
  }
}