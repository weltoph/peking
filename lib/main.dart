import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    SharedPreferences.getInstance().then((value) => value.clear());
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
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
      initialIndex: 0,
      length: 1,
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
                  ]
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            GameTab(),
          ]
        ),
      )
    );
  }
}
