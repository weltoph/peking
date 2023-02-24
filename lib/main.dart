import 'package:flutter/material.dart';
import 'strings.dart';
import 'case.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MainTabBar(),
    );
  }
}

class MainTabBar extends StatelessWidget {
  const MainTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            //title: const Text('First test'),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: TabBar(
                  tabs: <Widget>[
                    Tab(text: Strings.gameTabTitle),
                    Tab(text: Strings.galleryTabTitle),
                    Tab(text: Strings.settingTabTitle),
                  ]
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            GameTab(),
            Center( child: Text('this is the second tab'), ),
            Center( child: Text('this is the third tab'), ),
          ]
        ),
      )
    );
  }
}
