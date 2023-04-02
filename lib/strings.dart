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
    "yellow": "Gelben Drachen",
    "red": "Roten Drachen",
    "blue": "Blauen Drachen",
    "green": "Grünen Drachen",
  };

  static const Map<String, Map<bool, String>> sentences = {
    "hat": {
      true: "Ich sah eine Person mit einem Hut davonlaufen!",
      false: "Die Person war definitiv baren Hauptes.",
    },
    "scar": {
      true: "Die Person lief an mir vorbei, aber die Narbe auf ihrem Gesicht hat mich so sehr erschreckt, dass ich auf nichts anderes achten konnte.",
      false: "Wenn Sie mich so genau fragen dann bin ich mir ziemlich sicher, dass die Person, die an mir vorbeirannte, keine Narbe hatte.",
    },
    "scarf": {
      true: "Passend für diesen windigen Charakter wedelte ein Schal hinter ihr her!",
      false: "Mh, ich dachte noch die Person muss kaltes Wetter gewöhnt sein, da sie gar keinen Schal trug...",
    },
    "glasses": {
      true: "Die Brillengläser dieses Menschen blitzten schon so sinister...",
      false: "Ich errinere mich sehr gut an die stechenden Augen - eine Brille hätte diesen Augen etwas von ihrer Schärfe genommen.",
    },
  };
}