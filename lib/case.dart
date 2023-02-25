import 'dart:collection';

import 'package:flutter/material.dart';
import 'storyscreen.dart';
import 'settings.dart';
import 'strings.dart';
import 'utilities.dart';
import 'package:flutter/services.dart' show rootBundle;

class GameTab extends StatefulWidget {
  const GameTab({super.key});

  @override
  State<StatefulWidget> createState() => _GameTabState();
}

class _GameState {
  _Case testCase = const _Case(
    title: "Der zerbrochene Krug",
    initialPicture: "christophtalking.jpg",
    initialLines: "broken-initial.txt",
    finalLines: "broken-final.txt"
  );
}

class _Actor {
  final String name;
  final String filePrefix;
  _Actor({required this.name, required this.filePrefix});
}

class _Actors {
  static const List<String> identifyingProperties = [
    "0000",
    "0001",
    "0010",
    "0011",
    "0100",
    "0101",
    "0110",
    "0111",
    "1000",
    "1001",
    "1010",
    "1011",
    "1100",
    "1101",
    "1110",
    "1111",
  ];

  static const List<String> citizenHouses = [
    "washroom",
    "beauty",
    "jewelry",
    "restaurant",
    "port",
    "palace",
  ];

  static const List<String> dimensions = [
    "hat",
    "glasses",
    "scar",
    "scarf",
  ];

  static const List<String> extraHouses = [
    "temple",
    "market",
  ];

  static const List<String> hidingPlaces = [
    "yellow",
    "red",
    "blue",
    "green",
  ];

  final String perpetrator;
  final String hidingPlace;
  final List<String> suspects;
  final LinkedHashMap<String, _Actor> suspectPersons;
  final Map<String, _Actor> citizens;
  final Map<String, String> information;
  final String liar;
  final Map<String, _Actor> specialInformation;

  _Actors._({required this.perpetrator, required this.hidingPlace, required this.suspects, required this.suspectPersons, required this.citizens, required this.information, required this.liar, required this.specialInformation});

  static _Actors construct(List<_Actor> people, List<_Actor> animals) {
    assert(people.length >= 18);
    assert(animals.length >= 2);
    List<_Actor> chosen = choose(people, 18);
    List<String> roles = choose(identifyingProperties, 12);
    String perpetrator = roles[0];
    String hidingPlace = pick(hidingPlaces);
    List<String> suspects = roles.sublist(1);
    LinkedHashMap<String, _Actor> suspectPersons = LinkedHashMap.fromIterables(permutation(roles), chosen.sublist(0, 12));
    Map<String, _Actor> citizens = Map.fromIterables(citizenHouses, chosen.sublist(12));
    Map<String, String> information = Map.fromIterables(choose(citizenHouses, 4), dimensions);
    String liar = pick(citizenHouses);
    Map<String, _Actor> specialInformation = Map.fromIterables(extraHouses, choose(animals, 2));
    return _Actors._(
        perpetrator: perpetrator,
        hidingPlace: hidingPlace,
        suspects: suspects,
        suspectPersons: suspectPersons,
        citizens: citizens,
        information: information,
        liar: liar,
        specialInformation: specialInformation);
  }
}

class _Case {
  final String title;
  final String? initialPicture;
  final String initialLines;
  final String? finalPicture;
  final String finalLines;

  const _Case({required this.title, this.initialPicture, required this.initialLines, this.finalPicture, required this.finalLines});

  Future<StoryScreen> constructStoryScreen(String? picture, String text) async {
    List<Widget> finalChildren = List.empty(growable: true);
    finalChildren.add(
      Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: Strings.titleLineSpacing,
            bottom: Strings.titleLineSpacing,
          ),
          child: Text(
            title,
            style: Strings.titleLine,
            textAlign: TextAlign.center,
          ),
        ),
      )
    );
    if(picture != null) {
      finalChildren.add(
        Center(
          child: Image.asset(
            "pictures/$picture",
            height: Settings.pictureHeight,
          ),
        )
      );
    }
    Future<String> content = rootBundle.loadString("texts/$text");
    List<String> lines = (await content).split("\n");
    for(String line in lines) {
      if(line.isEmpty) { continue; }
      finalChildren.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: Strings.textLineSpacing,
              bottom: Strings.textLineSpacing,
            ),
            child: Text(
              line,
              style: Strings.textLines,
              textAlign: TextAlign.center,
            ),
          ),
        )
      );
    }
    return StoryScreen(widgets: finalChildren);
  }
}


class _CaseCard extends StatelessWidget {
   final Widget child;
   final Widget display;
   const _CaseCard({required this.child, required this.display});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => display,
              )
            );
          },
          child: SizedBox(
            width: double.infinity,
            height: 150,
            child: Center(child: child),
          )
        )
      )
    );
  }
}

class _GameTabState extends State<GameTab> {
  _GameState? _game;

  void initializeNewGame() {
    setState(() {
      _game = _GameState();
    });
  }

  Future<Widget> _getCase(BuildContext context) async {
    // check for stored case
    // otherwise create case
    // construct case
    return Column(
      children: [
        FutureBuilder<Widget>(
          future: _game!.testCase.constructStoryScreen(_game!.testCase.initialPicture, _game!.testCase.initialLines),
          builder: (context, AsyncSnapshot<Widget> widget) {
            if(widget.hasData) {
              return _CaseCard(
                display: widget.requireData,
                child: const Text("initial"),
              );
            } else {
              return Strings.loadingCard;
            }
          }
        ),
        FutureBuilder<Widget>(
            future: _game!.testCase.constructStoryScreen(_game!.testCase.finalPicture, _game!.testCase.finalLines),
            builder: (context, AsyncSnapshot<Widget> widget) {
              if(widget.hasData) {
                return _CaseCard(
                  display: widget.requireData,
                  child: const Text("final"),
                );
              } else {
                return Strings.loadingCard;
              }
            }
        ),
      ],
    );
  }


  Widget _build(BuildContext context) {
    if(_game == null) {
      return const Text(Strings.noGameAvailable);
    } else {
      return FutureBuilder<Widget>(
          future: _getCase(context),
          builder: (context, AsyncSnapshot<Widget> widget) {
            if(widget.hasData) {
              return widget.requireData;
            } else {
              return const Text("waiting for data");
            }
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _build(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: initializeNewGame,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
