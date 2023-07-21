import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';
import 'package:news_app/api/spaceflight.dart';
import 'package:news_app/cards.dart';
import 'package:news_app/handler/storage.dart';
import 'package:news_app/views/saved.dart';
import 'package:provider/provider.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => MainStore(), child: const MainApp()));
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
    context.read<MainStore>().getLocalStorage();
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
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          systemNavigationBarColor: ElevationOverlay.applySurfaceTint(
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceTint,
              3)),
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          // change brightnes of the background color
          appBar: AppBar(
            leading: const Icon(Icons.newspaper),
            title: const Text(
              "Newsy",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    enableDrag: true,
                    builder: (context) {
                      return const SettingsPage();
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
          body: homeView(context)),
    );
  }

  Widget homeView(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      _news.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              cacheExtent: 40,
              children: _news
                  .map((news) => NewsCard(
                        news: news,
                        showBookMark: true,
                      ))
                  .toList()),
      SavedView(
        context: context,
      )
    ];
    return PageView(
        controller: _pageController,
        children: widgetOptions,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        });
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text(
                "Theme",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              const Text(
                "Use your system theme changer lol.",
                style: TextStyle(fontSize: 15),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  "Social Links",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.code,
                ),
                onPressed: () {
                  _launchURL(context, "https://github.com/piyushsuthar/newsy");
                },
              ),
            ],
          ),
        ],
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
