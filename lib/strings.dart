import 'package:flutter/material.dart';

class Strings {
  Strings._();
  static const String gameTabTitle = "Spiel";
  static const String noGameAvailable = "Noch kein Spiel bereit... :-(";
  static const String galleryTabTitle = "Gallerie";
  static const String settingTabTitle = "Einstellungen";
  static const TextStyle textLines = TextStyle(
    fontSize: 50,
    fontStyle: FontStyle.italic,
  );
  static const TextStyle titleLine = TextStyle(
    fontSize: 75,
    fontStyle: FontStyle.italic,
  );
  static const double pictureHeight = 250;
  static const Card loadingCard = Card(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
            width: double.infinity,
            height: 150,
            child: Center(child: Text("waiting for data"),
          )
      )
  );
}