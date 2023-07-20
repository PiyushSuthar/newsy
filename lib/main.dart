import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:news_app/api/spaceflight.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Result> _news = [];

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  void _getNews() async {
    _news = (await NewsApi.getNews());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  builder: (context) {
                    return const SizedBox(
                      height: 300,
                      child: Center(
                        child: Text("Settings"),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(Icons.newspaper),
              icon: Icon(Icons.newspaper_outlined),
              label: 'News',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.bookmark),
              icon: Icon(Icons.bookmark_border),
              label: 'Saved',
            ),
          ],
        ),
        body: _news.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: _news
                    .map((news) => NewsCard(
                        title: news.title.toString(),
                        subtitle: news.summary.toString(),
                        image: news.imageUrl))
                    .toList()));
  }
}

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: const Center(
        child: Text("Settings"),
      ),
    );
  }
}
