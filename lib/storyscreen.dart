import 'package:flutter/material.dart';

class StoryScreen extends StatefulWidget {
  final List<Widget> widgets;
  late final List<bool> visibleWidgets;

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
          duration: const Duration(milliseconds: 700),
          onEnd: () {
            if(i+1 < widget.widgets.length && mounted) { setState(() { widget.visibleWidgets[i+1] = true; }); } },
          child: Container(
            child: widget.widgets.elementAt(i),
          )
      ));
    }
    Future.delayed(
      const Duration(seconds: 1),
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
