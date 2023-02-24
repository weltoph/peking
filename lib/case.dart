import 'package:flutter/material.dart';
import 'storyscreen.dart';
import 'strings.dart';
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
            child: Text(
              title,
              style: Strings.titleLine,
              textAlign: TextAlign.center,
            ),
        )
    );
    if(picture != null) {
      finalChildren.add(
        Center(
          child: Image.asset(
            "pictures/$picture",
            height: Strings.pictureHeight,
          ),
        )
      );
    }
    Future<String> content = rootBundle.loadString("texts/$text");
    List<String> lines = (await content).split("\n");
    for(String line in lines) {
      finalChildren.add(
        Center(
          child: Text(
            line,
            style: Strings.textLines,
            textAlign: TextAlign.center,
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
      ),
    );
  }
}
