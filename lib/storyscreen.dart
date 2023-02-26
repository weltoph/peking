import 'package:flutter/material.dart';
import 'settings.dart';
import 'strings.dart';

class StoryScreen extends StatefulWidget {
  final List<Widget> widgets;
  late final List<bool> visibleWidgets;
  
  static Widget constructTitle(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: Strings.titleLineSpacing,
          bottom: Strings.titleLineSpacing,
        ),
        child: Text(
          text,
          style: Strings.titleLine,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  
  static Widget constructPicture(String picture) {
    return Center(
      child: Image.asset(
        "pictures/$picture",
        height: Settings.pictureHeight,
      ),
    );
  }
  
  static Widget constructLine(String line) {
    return Center(
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
    );
  }

  StoryScreen({super.key, required this.widgets}) {
    visibleWidgets = List.filled(widgets.length, false);
  }

  @override
  State<StatefulWidget> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> fadedWidgets = List.empty(growable: true);
    for(int i=0; i < widget.widgets.length; i++) {
      fadedWidgets.add(AnimatedOpacity(
          opacity: widget.visibleWidgets.elementAt(i) ? 1.0 : 0.0,
          duration: Duration(milliseconds: Settings.textFadeTime),
          onEnd: () {
            if(i+1 < widget.widgets.length && mounted) { setState(() { widget.visibleWidgets[i+1] = true; }); } },
          child: Container(
            child: widget.widgets.elementAt(i),
          )
      ));
    }
    Future.delayed(
      Duration(milliseconds: Settings.initialFadeTime),
        () {
          if(mounted) {setState(() {widget.visibleWidgets[0] = true;});}
        }
    );
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: Column(
        children: fadedWidgets,
      ),
    );
  }

}
