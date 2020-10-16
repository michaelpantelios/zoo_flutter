import 'package:flutter/material.dart';
import 'package:zoo_flutter/models/app_info.dart';
import 'package:zoo_flutter/apps/home/home.dart';
import 'package:zoo_flutter/models/home_module_info.dart';

 enum appIds  {home, chat, forum, games, search, profile, star, coins, messenger, notifications, settings}

class DataMocker {
  DataMocker._privateConstructor();

  static final DataMocker _instance = DataMocker._privateConstructor();

  static DataMocker get instance {
    return _instance;
  }

  static Map apps = {
    "home" : new AppInfo(
      appId: "home",
      appName: "app_name_home",
      appType: AppType.full,
      iconPath: Icons.home_filled,
      appWidget: Home()
    ),
    "chat" : new AppInfo(
      appId: "chat",
      appName: "app_name_chat",
      appType: AppType.full,
      iconPath: Icons.chat_bubble,
      appWidget: Container()
    ),
    "forum" : new AppInfo(
      appId: "forum",
      appName: "app_name_forum",
      appType: AppType.full,
      iconPath: Icons.notes,
      appWidget: Container()
    ),
    "games" : new AppInfo(
      appId: "games",
      appName: "app_name_games",
      appType: AppType.full,
      iconPath: Icons.casino,
      appWidget: Container()
    ),
    "search" : new AppInfo(
      appId: "search",
      appName: "app_name_search",
      appType: AppType.full,
      iconPath: Icons.search,
      appWidget: Container()
    ),
    "profile": new AppInfo(
      appId: "profile",
      appName: "app_name_profile",
      appType: AppType.popup,
      iconPath: Icons.face,
      appWidget: Container()
    ),
    "star": new AppInfo(
      appId: "star",
      appName: "app_name_star",
      appType: AppType.popup,
      iconPath: Icons.star,
      appWidget: Container()
    ),
    "coins": new AppInfo(
      appId: "coins",
      appName: "app_name_coins",
      appType: AppType.popup,
      iconPath: Icons.copyright,
      appWidget: Container()
    ),
    "messenger": new AppInfo(
      appId: "messenger",
      appName: "app_name_messenger",
      appType: AppType.full,
      iconPath: Icons.comment,
      appWidget: Container()
    ),
    "notifications": new AppInfo(
      appId: "notifications",
      appName: "app_name_notifications",
      appType: AppType.dropdown,
      iconPath: Icons.notifications,
      appWidget: Container()
    ),
    "settings": new AppInfo(
      appId: "settings",
      appName: "app_name_settings",
      appType: AppType.dropdown,
      iconPath: Icons.settings,
      appWidget: Container()
    ),
  };

  static List<HomeModuleInfo> homeModules = [
    new HomeModuleInfo(
      title: "Το νέο Zoo.gr είναι γεγονός!",
      mainText: "Η νέα σύνθεση του Zoo.gr με μπλε και πράσινους κόκκους εξαφανίζει τη βαρεμάρα και τη μοναξιά. Τώρα, στο zoo.gr θα βγάλετε γκόμενα, τα απωθημένα σας, και ό,τι άλλο γουστάρετε!",
      position: ModulePosition.left
    ),
    new HomeModuleInfo(
      title: "H Violet σε περιμένει...",
      imagePath: "images/home/violets.jpg",
      position: ModulePosition.middle
    ),
    new HomeModuleInfo(
      title: "Νέο παιχνίδι στο zoo.gr!",
      imagePath: "images/home/yatzy.png",
      mainText: "Το καινούριο Yatzy τα σπάει μιλάμε",
      position: ModulePosition.right
    )
  ];

}