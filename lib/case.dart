import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storyscreen.dart';
import 'strings.dart';
import 'utilities.dart';
import 'settings.dart';
import 'package:flutter/services.dart' show rootBundle;

class GameTab extends StatefulWidget {
  const GameTab({super.key});

  @override
  State<StatefulWidget> createState() => _GameTabState();
}

class _GameState {
  final _Case crime;
  final _Actors actors;

  _GameState._({required this.crime, required this.actors});

  static Future<_GameState> constructAndStore(SharedPreferences preferences) async {
    Map<String, dynamic> cases = jsonDecode(await rootBundle.loadString(Settings.casesConfigurationFile));
    Map<String, dynamic> pictures = jsonDecode(await rootBundle.loadString(Settings.picturesConfigurationFile));
    final Map<String, dynamic> chosenCase = pick(cases["cases"] as List<dynamic>) as Map<String, dynamic>;
    final _Case constructedCase = _Case.fromJSON(chosenCase);
    final List<_Actor> people = (pictures["people"] as List<dynamic>).map((actor) => _Actor(name: actor["name"]!, filePrefix: actor["filePrefix"]!)).toList();
    final List<_Actor> animals = (pictures["animals"] as List<dynamic>).map((actor) => _Actor(name: actor["name"]!, filePrefix: actor["filePrefix"]!)).toList();
    final _Actors actors = _Actors.construct(people, animals);
    final _GameState state = _GameState._(crime: constructedCase, actors: actors);
    store(state, preferences);
    return state;
  }

  static void store(_GameState state, SharedPreferences preferences) async {
    String json = jsonEncode({ "case": state.crime.toJSON(), "actors": state.actors.toJSON() });
    debugPrint(json);
    preferences.setString("case", json);
  }

  static Future<_GameState> load(String encodedState) async {
    final Map<String, dynamic> state = jsonDecode(encodedState);
    final _Case crime = _Case.fromJSON(state["case"]);
    final _Actors actors = _Actors.fromJSON(state["actors"]);
    return _GameState._(crime: crime, actors: actors);
  }

  static Future<_GameState> constructOrLoad() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.containsKey("case") ? load(preferences.getString("case")!) : constructAndStore(preferences);
  }
}

class _Actor {
  final String name;
  final String filePrefix;
  _Actor({required this.name, required this.filePrefix});

  static _Actor fromJSON(Map<String, dynamic> mapping) {
    assert(mapping.containsKey("name"));
    assert(mapping.containsKey("filePrefix"));
    final String name = mapping["name"];
    final String filePrefix = mapping["filePrefix"];
    return _Actor(
      name: name,
      filePrefix: filePrefix,
    );
  }

  Map<String, String> toJSON() {
    return {
      "name": name,
      "filePrefix": filePrefix,
    };
  }
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
    debugPrint(perpetrator);
    debugPrint(hidingPlace);
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

  static _Actors fromJSON(Map<String, dynamic> mapping) {
    assert(mapping.containsKey("perpetrator"));
    assert(mapping.containsKey("hidingPlace"));
    assert(mapping.containsKey("suspects"));
    assert(mapping.containsKey("suspectPersons"));
    assert(mapping.containsKey("citizens"));
    assert(mapping.containsKey("information"));
    assert(mapping.containsKey("liar"));
    assert(mapping.containsKey("specialInformation"));
    String perpetrator = mapping["perpetrator"]!;
    String hidingPlace = mapping["hidingPlace"]!;
    assert(mapping["suspects"]!.runtimeType == List);
    assert(!(mapping["suspects"] as List<dynamic>).any((e) => e.runtimeType != String));
    List<String> suspects = (mapping["suspects"]! as List<dynamic>).map((e) => e as String).toList(growable: false);
    LinkedHashMap<String, _Actor> suspectPersons = LinkedHashMap.of((mapping["suspectPersons"]! as Map<String, dynamic>).map((key, value) => MapEntry(key, _Actor.fromJSON(value))));
    Map<String, _Actor> citizens = (mapping["citizens"]! as Map<String, dynamic>).map((key, value) => MapEntry(key, _Actor.fromJSON(value)));
    Map<String, String> information = (mapping["information"]! as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String));
    String liar = mapping["liar"]!;
    Map<String, _Actor> specialInformation = (mapping["specialInformation"]! as Map<String, dynamic>).map((key, value) => MapEntry(key, _Actor.fromJSON(value)));
    return _Actors._(
      perpetrator: perpetrator,
      hidingPlace: hidingPlace,
      suspects: suspects,
      suspectPersons: suspectPersons,
      citizens: citizens,
      information: information,
      liar: liar,
      specialInformation: specialInformation,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "perpetrator": perpetrator,
      "hidingPlace": hidingPlace,
      "suspects": suspects,
      "suspectPersons": suspectPersons.map((key, value) => MapEntry(key, value.toJSON())),
      "citizens": citizens.map((key, value) => MapEntry(key, value.toJSON())),
      "information": information,
      "liar": liar,
      "specialInformation": specialInformation.map((key, value) => MapEntry(key, value.toJSON())),
    };
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
      finalChildren.add(StoryScreen.constructLine("Es tut mir leid; ich habe von diesem schrecklichen Verbrechen gar nichts mitbekommen."));
    } else {
      String dimension = information[location] as String;
      bool result = _getProperty(dimension);
      if(liar == location) {
        result = !result;
      }
      finalChildren.add(StoryScreen.constructLine(Strings.sentences[dimension]![result]!));
    }
    return StoryScreen(
      widgets: finalChildren,
    );
  }

  AlertDialog Function(BuildContext) _searchDialog(String which, _Actor actor) {
    return (BuildContext context) {
      return AlertDialog(
        title: const Text("Where are you looking?"),
        content:
        Row(
          mainAxisSize: MainAxisSize.min,
            children: hidingPlaces.map(
                    (e) => Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Settings.hidingPlacesColors[e])
                          ),
                          onPressed: () {Navigator.of(context).pop(which == perpetrator && e == hidingPlace);},
                          child: Container(),
                        )
                    )
            ).toList()
        )
      );
    };
  }

  Future<Widget> constructWanted(BuildContext context, Widget finalScreen, Widget failScreen) async {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: suspectPersons.entries.map(
                  (e) => GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: _searchDialog(e.key, e.value))
                        .then((value) {
                          if(value == null) { return; }
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return value ? finalScreen : failScreen;
                              },));
                    });
                  },
                  child: Image.asset("pictures/${e.value.filePrefix}${e.key}.jpg", width: 100,)
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
      finalChildren.add(StoryScreen.constructLine("Eine Aura der Ruhe umgibt diesen Ort."));
      finalChildren.add(StoryScreen.constructLine("Du fühlst, dass es in dieser Stadt keinen Lügner geben kann."));
    } else {
      finalChildren.add(StoryScreen.constructPicture("${specialInformation["temple"]!.filePrefix}mad.jpg"));
      finalChildren.add(StoryScreen.constructLine("Du siehst wie ${specialInformation["temple"]!.name} Richtung ${Strings.locationNames[liar]} läuft."));
      finalChildren.add(StoryScreen.constructLine("Wahrscheinlich lügt ${citizens[liar]!.name}."));
    }
    return StoryScreen(
      widgets: finalChildren,
    );
  }

  Future<Widget> constructNinja() async {
    List<Widget> finalChildren = List.empty(growable: true);
    finalChildren.add(StoryScreen.constructTitle(specialInformation["market"]!.name));
    finalChildren.add(StoryScreen.constructPicture("${specialInformation["market"]!.filePrefix}run.jpg"));
    finalChildren.add(StoryScreen.constructLine("Die feine Spürnase schlägt an."));
    finalChildren.add(StoryScreen.constructLine("Du siehst ${specialInformation["market"]!.name} zum ${Strings.hidingNames[hidingPlace]} laufen!"));

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
  final String? failPicture;
  final String failLines;

  const _Case({required this.title, this.initialPicture, required this.initialLines, this.finalPicture, required this.finalLines, this.failPicture, required this.failLines});
  static _Case fromJSON(Map<String, dynamic> mapping) {
    assert(mapping.containsKey("title"));
    assert(mapping.containsKey("initialText"));
    assert(mapping.containsKey("finalText"));
    assert(mapping.containsKey("failText"));
    String title = mapping["title"]!;
    String initialLines = mapping["initialText"]!;
    String finalLines = mapping["finalText"]!;
    String failLines = mapping["failText"]!;
    String? initialPicture = mapping["initialPicture"];
    String? finalPicture = mapping["finalPicture"];
    String? failPicture = mapping["failPicture"];
    return _Case(
      title: title,
      initialLines: initialLines,
      finalLines: finalLines,
      failLines: failLines,
      initialPicture: initialPicture,
      finalPicture: finalPicture,
      failPicture: failPicture,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "title": title,
      "initialPicture": initialPicture,
      "initialText": initialLines,
      "finalPicture": finalPicture,
      "finalText": finalLines,
      "failPicture": failPicture,
      "failText": failLines,
    };
  }

  Future<StoryScreen> getInitial() async => _constructStoryScreen(initialPicture, initialLines);
  Future<StoryScreen> getFinal() async => _constructStoryScreen(finalPicture, finalLines);
  Future<StoryScreen> getFail() async => _constructStoryScreen(failPicture, failLines);

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
      _game = null;
      SharedPreferences.getInstance().then((value) => value.remove("case"));
    });
  }

  Future<Widget> _constructCard(Future<Widget> Function() f, Widget title) async {
    return _CaseCard(
      display: await f(),
      child: title,
    );
  }

  Future<Widget> _getCase(BuildContext context) async {
    // check for stored case
    _game ??= await _GameState.constructOrLoad();
    // construct case
    _GameState actualGame = _game!;

    Widget finalScreen = await actualGame.crime.getFinal();
    Widget initialScreen = await _constructCard(() => actualGame.crime.getInitial(), const Text("Der Fall", style: TextStyle(
      fontFamily: "Shanghai",
      fontSize: 30,
    ),));
    Widget failScreen = await actualGame.crime.getFail();
    Widget washroom = await _constructCard(() => actualGame.actors.constructLocation("washroom"), actualGame.actors.constructCardTitle("washroom"));
    Widget beauty = await _constructCard(() => actualGame.actors.constructLocation("beauty"), actualGame.actors.constructCardTitle("beauty"));
    Widget jewelry = await _constructCard(() => actualGame.actors.constructLocation("jewelry"), actualGame.actors.constructCardTitle("jewelry"));
    Widget restaurant = await _constructCard(() => actualGame.actors.constructLocation("restaurant"), actualGame.actors.constructCardTitle("restaurant"));
    Widget port = await _constructCard(() => actualGame.actors.constructLocation("port"), actualGame.actors.constructCardTitle("port"));
    Widget palace = await _constructCard(() => actualGame.actors.constructLocation("palace"), actualGame.actors.constructCardTitle("washroom"));
    Widget temple = await _constructCard(() => actualGame.actors.constructOldMan(), actualGame.actors.constructCardTitle("temple"));
    Widget market = await _constructCard(() => actualGame.actors.constructNinja(), actualGame.actors.constructCardTitle("market"));
    Widget wanted = await _constructCard(() => actualGame.actors.constructWanted(context, finalScreen, failScreen), const Text("Verdächtige", style: TextStyle(
      fontFamily: "Shanghai",
      fontSize: 30,
    ),));
    return ListView(
      scrollDirection: Axis.vertical,
      children: [initialScreen, wanted, washroom, beauty, jewelry, restaurant, port, palace, temple, market],
    );
  }


  Widget _build(BuildContext context) {
    return FutureBuilder<Widget>(
        future: _getCase(context),
        builder: (context, AsyncSnapshot<Widget> widget) {
          if(widget.hasData) {
            return widget.requireData;
          } else {
            return const CircularProgressIndicator();
          }
        }
    );
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
