import 'package:flutter/material.dart';

class Strings {
  Strings._();
  static const String gameTabTitle = "Spiel";
  static const String noGameAvailable = "Noch kein Spiel bereit... :-(";
  static const String galleryTabTitle = "Gallerie";
  static const String settingTabTitle = "Einstellungen";
  static const double textLineSpacing = 20;
  static const double titleLineSpacing = 20;
  static const TextStyle textLines = TextStyle(
    fontSize: 50,
    fontStyle: FontStyle.italic,
  );
  static const TextStyle titleLine = TextStyle(
    fontSize: 75,
    fontStyle: FontStyle.italic,
  );
  static const Card loadingCard = Card(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
          height: 150,
          child: Center(
            child: CircularProgressIndicator(),
          )
      )
  );
  static const Map<String, String> locationNames = {
    "washroom": "Wäscherei",
    "beauty": "Schönheitssalon",
    "jewelry": "Juwelierladen",
    "restaurant": "Restaurant",
    "port": "Hafen",
    "palace": "Jadepalast",
    "temple": "Temple",
    "market": "Markt",
  };

  static const Map<String, String> hidingNames = {
    "yellow": "Gelber Drache",
    "red": "Roter Drache",
    "blue": "Blauer Drache",
    "green": "Grüner Drache",
  };
}