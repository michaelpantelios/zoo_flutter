import 'package:zoo_flutter/models/app_button_info.dart';
import 'package:flutter/material.dart';

class DataMocker {
  DataMocker._privateConstructor();

  static final DataMocker _instance = DataMocker._privateConstructor();

  static DataMocker get instance {
    return _instance;
  }

  static List<AppButtonInfo> appButtonsList = [
    AppButtonInfo(appId: "home", appName: "app_name_home", iconPath: Icons.home_filled, order: 1),
    AppButtonInfo(appId: "chat", appName: "app_name_chat", iconPath: Icons.chat_bubble, order: 2),
    AppButtonInfo(appId: "games", appName: "app_name_games", iconPath: Icons.gamepad, order: 3),
    AppButtonInfo(appId: "forum", appName: "app_name_forum", iconPath: Icons.notes, order: 4),
    AppButtonInfo(appId: "search", appName: "app_name_search", iconPath: Icons.search, order: 5)
  ];


}