
import 'package:flutter/material.dart';

class Settings {
  Settings._();
  static int textFadeTime = 600;
  static int initialFadeTime = 1000;
  static double pictureHeight = 250;

  static String casesConfigurationFile = "configurations/cases.json";
  static String picturesConfigurationFile = "configurations/pictures.json";

  static Map<String, MaterialColor> hidingPlacesColors = {
    "yellow": Colors.yellow,
    "red": Colors.red,
    "blue": Colors.blue,
    "green": Colors.green,
  };
}