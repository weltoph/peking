import 'dart:collection';

import 'package:flutter/material.dart';
import 'storyscreen.dart';
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

  _Actors testActors = _Actors.construct(
    [
      _Actor(
        name: "Christoph",
        filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
      _Actor(
          name: "Christoph",
          filePrefix: "christoph"
      ),
    ], [
    _Actor(
        name: "Sam",
        filePrefix: "sam"
    ),
    _Actor(
        name: "Sam",
        filePrefix: "sam"
    ),
  ]);
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
    "scarf",
    "hat",
    "glasses",
    "scar",
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

  bool _getProperty(String which) {
    assert(dimensions.contains(which));
    int index = dimensions.indexOf(which);
    return perpetrator.substring(index, index+1) == "1";
  }

  Future<Widget> constructLocation(String location) async {
    assert(citizenHouses.contains(location));
    List<Widget> finalChildren = List.empty(growable: true);
    finalChildren.add(StoryScreen.constructTitle(citizens[location]!.name));
    finalChildren.add(StoryScreen.constructPicture("${citizens[location]!.filePrefix}talking.jpg"));
    // does not know anything
    if(!information.containsKey(location)) {
      finalChildren.add(StoryScreen.constructLine("I don't know anything!"));
    } else {
      String dimension = information[location] as String;
      bool result = _getProperty(dimension);
      if(liar == location) {
        result = !result;
      }
      finalChildren.add(StoryScreen.constructLine("$dimension: $result"));
    }
    return StoryScreen(
      widgets: finalChildren,
    );
  }

  Future<Widget> constructWanted(BuildContext context) async {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: suspectPersons.entries.map(
                  (e) => IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Where are you looking?"),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.yellow),
                                            ),
                                            child: Container(
                                            ),
                                            onPressed: () => Navigator.of(context).pop(),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.red),
                                            ),
                                            child: Container(
                                            ),
                                            onPressed: () => Navigator.of(context).pop(),
                                          ),
                                        ),
                                      ]
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.green),
                                          ),
                                          child: Container(
                                          ),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                                          ),
                                          child: Container(
                                          ),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    icon: Image.asset("pictures/${e.value.filePrefix}${e.key}.jpg", width: 100,)
                  )
          ).toList(),
        )
    );
  }

  Future<Widget> constructOldMan() async {
    List<Widget> finalChildren = List.empty(growable: true);
    finalChildren.add(StoryScreen.constructTitle(specialInformation["temple"]!.name));
    // does not know anything
    if(!information.containsKey(liar)) {
      finalChildren.add(StoryScreen.constructPicture("${specialInformation["temple"]!.filePrefix}content.jpg"));
      finalChildren.add(StoryScreen.constructLine("No evil, so sleepy!"));
    } else {
      finalChildren.add(StoryScreen.constructPicture("${specialInformation["temple"]!.filePrefix}mad.jpg"));
      finalChildren.add(StoryScreen.constructLine("No time for sleep!"));
      finalChildren.add(StoryScreen.constructLine("${citizens[liar]!.name} at ${Strings.locationNames[liar]} is evil."));
      finalChildren.add(StoryScreen.constructLine("For Justice!"));
    }
    return StoryScreen(
      widgets: finalChildren,
    );
  }

  Widget _getSizedAvatar(_Actor of) {
    return Image.asset(
      "pictures/${of.filePrefix}avatar.jpg",
      height: 100,
    );
  }

  Widget constructCardTitle(String location) {
    assert(citizenHouses.contains(location) || extraHouses.contains(location));
    _Actor who = (citizenHouses.contains(location) ? citizens[location] : specialInformation[location]) as _Actor;
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: _getSizedAvatar(who),
        ),
        Text(
          Strings.locationNames[location] as String,
          style: const TextStyle(
            fontFamily: "Shanghai",
            fontSize: 30,
          )
        )
      ],
    );
  }

}

class _Case {
  final String title;
  final String? initialPicture;
  final String initialLines;
  final String? finalPicture;
  final String finalLines;

  const _Case({required this.title, this.initialPicture, required this.initialLines, this.finalPicture, required this.finalLines});

  Future<StoryScreen> getInitial() async => _constructStoryScreen(initialPicture, initialLines);
  Future<StoryScreen> getFinal() async => _constructStoryScreen(finalPicture, finalLines);

  Future<StoryScreen> _constructStoryScreen(String? picture, String text) async {
    List<Widget> finalChildren = List.empty(growable: true);
    finalChildren.add(StoryScreen.constructTitle(title));
    if(picture != null) {
      finalChildren.add(StoryScreen.constructPicture(picture));
    }
    Future<String> content = rootBundle.loadString("texts/$text");
    List<String> lines = (await content).split("\n");
    for(String line in lines) {
      if(line.isEmpty) { continue; }
      finalChildren.add(StoryScreen.constructLine(line));
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

  FutureBuilder<Widget> _constructCard(Future<Widget> Function() f, Widget title) {
    return FutureBuilder<Widget>(
        future: f(),
        builder: (context, AsyncSnapshot<Widget> widget) {
          if(widget.hasData) {
            return _CaseCard(
              display: widget.requireData,
              child: title,
            );
          } else {
            return Strings.loadingCard;
          }
        }
    );
  }

  Future<Widget> _getCase(BuildContext context) async {
    // check for stored case
    // otherwise create case
    // construct case
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        _constructCard(() => _game!.testCase.getInitial(), const Text("initial")),
        _constructCard(() => _game!.testActors.constructLocation("washroom"), _game!.testActors.constructCardTitle("washroom")),
        _constructCard(() => _game!.testActors.constructLocation("beauty"), _game!.testActors.constructCardTitle("beauty")),
        _constructCard(() => _game!.testActors.constructLocation("jewelry"), _game!.testActors.constructCardTitle("jewelry")),
        _constructCard(() => _game!.testActors.constructLocation("restaurant"), _game!.testActors.constructCardTitle("restaurant")),
        _constructCard(() => _game!.testActors.constructLocation("port"), _game!.testActors.constructCardTitle("port")),
        _constructCard(() => _game!.testActors.constructLocation("palace"), _game!.testActors.constructCardTitle("palace")),
        _constructCard(() => _game!.testActors.constructOldMan(), _game!.testActors.constructCardTitle("temple")),
        _constructCard(() => _game!.testActors.constructWanted(context), const Text("wanted")),
        _constructCard(() => _game!.testCase.getFinal(), const Text("final")),
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
