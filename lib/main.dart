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
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _getNews() async {
    _news = (await NewsApi.getNews());
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
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
          onDestinationSelected: (value) {
            _onItemTapped(value);
          },
          selectedIndex: _selectedIndex,
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
        body: homeView(context));
  }

  Widget homeView(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      _news.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: _news
                  .map((news) => NewsCard(
                      title: news.title.toString(),
                      subtitle: news.summary.toString(),
                      image: news.imageUrl))
                  .toList()),
      savedViews(context)
    ];
    return PageView(
        controller: _pageController,
        children: widgetOptions,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        });
  }

  Widget savedViews(BuildContext context) {
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
