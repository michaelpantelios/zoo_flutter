import 'package:flutter/material.dart';
import 'package:zoo_flutter/apps/forum/forum.dart';
import 'package:zoo_flutter/models/apps/app_info.dart';
import 'package:zoo_flutter/apps/home/home.dart';
import 'package:zoo_flutter/apps/coins/coins.dart';
import 'package:zoo_flutter/models/home/home_module_info.dart';
import 'package:zoo_flutter/models/forum/forum_topic.dart';
import 'package:zoo_flutter/models/forum/forum_reply.dart';
import 'package:zoo_flutter/models/forum/forum_category.dart';
import 'package:zoo_flutter/models/user/user_info.dart';

 enum appIds  {home, chat, forum, games, search, profile, star, coins, messenger, notifications, settings}

class DataMocker {
  DataMocker._privateConstructor();

  static final DataMocker _instance = DataMocker._privateConstructor();

  static DataMocker get instance {
    return _instance;
  }

  //apps

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
      appWidget: Forum()
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
      iconPath: Icons.account_box,
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
      appWidget: Coins()
    ),
    "messenger": new AppInfo(
      appId: "messenger",
      appName: "app_name_messenger",
      appType: AppType.full,
      iconPath: Icons.comment,
      appWidget: Container()
    ),
    "notificationsDropdown": new AppInfo(
      appId: "notificationsDropdown",
      appName: "app_name_notificationsDropdown",
      appType: AppType.dropdown,
      iconPath: Icons.notifications,
      appWidget: Container()
    ),
    "settingsDropdown": new AppInfo(
      appId: "settingsDropdown",
      appName: "app_name_settingsDropdown",
      appType: AppType.dropdown,
      iconPath: Icons.settings,
      appWidget: Container()
    )
  };

  //users

  static List<UserInfo> users = [
    new UserInfo(userId: 0, username: "Mitsos", sex: UserSex.Boy, star: true, photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/2c98e7fa0f909d062de8549d9a7dfc33.png"),
    new UserInfo(userId: 1, username: "Mixos", sex: UserSex.Boy, star: true),
    new UserInfo(userId: 2, username: "Yannos", sex: UserSex.Boy, star: true, photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/1a65108a6db3a4ec545f006233c53a31.png"),
    new UserInfo(userId: 3, username: "Giorgos", sex: UserSex.Boy, star: false, photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/d510d643afae021c4e1dbc7ce1eb3f0a.png"),
    new UserInfo(userId: 4, username: "Stefan", sex: UserSex.Boy, star: false),
    new UserInfo(userId: 5, username: "Stellakrou", sex: UserSex.Girl, star: true),
    new UserInfo(userId: 6, username: "Violeta", sex: UserSex.Girl, star: false),
    new UserInfo(userId: 7, username: "Popara", sex: UserSex.Girl, star: true, photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/237e51c6142589e9333258ebda2f2f09.png"),
    new UserInfo(userId: 8, username: "Mixalios", sex: UserSex.Boy, star: false),
    new UserInfo(userId: 9, username: "Kavlikos", sex: UserSex.Boy, star: true),
    new UserInfo(userId: 10, username: "SouziTsouzi", sex: UserSex.Girl, star: false, photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/6a39b1515f279f8cd73877503d24f7ab.png")
  ];


  //home app

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

  //forum app
  static List<ForumCategory> forumCategories = [
    new ForumCategory(id: 0, name: "Καφενείο"),
    new ForumCategory(id: 1, name: "Σχέσεις"),
    new ForumCategory(id: 2, name: "Τεχνολογία"),
    new ForumCategory(id: 3, name: "Αθλητικά"),
    new ForumCategory(id: 4, name: "Πολιτική"),
    new ForumCategory(id: 5, name: "Φιλοσοφία"),
    new ForumCategory(id: 6, name: "Τέχνες"),
    new ForumCategory(id: 7, name: "AutoMoto")
  ];

  static List<ForumTopic> forumTopics = [
    new ForumTopic(
        id: 0,
        ownerId: 0,
        categoryId: 1,
        title: "Gia ola ftaine oi gomenes",
        date: DateTime.now(),
        text: "... oi prwin ki oi epomenes... ",
        views: 666
    ),
    new ForumTopic(
        id: 1,
        ownerId: 2,
        categoryId: 0,
        title: "Covid-19",
        date: DateTime.now(),
        text: "Araiwnete!",
        views: 666
    ),
    new ForumTopic(
        id: 2,
        ownerId: 2,
        categoryId: 0,
        title: "Bastate Tourkoi t'aloga",
        date: DateTime.now(),
        text: "Kalos tourkos einai o nekros tourkos!",
        views: 666
    ),
    new ForumTopic(
        id: 3,
        ownerId: 3,
        categoryId: 2,
        title: "Nees texnologies",
        date: DateTime.now(),
        text: "To flutter einai to kalytero",
        views: 666
    ),
    new ForumTopic(
        id: 4,
        ownerId: 5,
        categoryId: 0,
        title: "Pws sas fainetai to neo zoo?",
        date: DateTime.now(),
        text: "Gamaei!",
        views: 666
    )
  ];

  List<ForumTopic> getManyTopics() {
    List<ForumTopic> manyTopics = new List<ForumTopic>();

    for (int i=0; i<1000; i++){
      manyTopics.add(
          new ForumTopic(
              id: i,
              ownerId: 0,
              categoryId: 0,
              title: "Θέμα "+i.toString(),
              date: DateTime.now(),
              text: "<u>Κείμενο <span style='color:rgb(1, 1, 0); font-size:18px;'>Θέματος</span> "+i.toString()+"</u>",
              views: 666
          )
      );
    }

    for (int i=manyTopics.length; i<2000; i++){
      manyTopics.add(
          new ForumTopic(
              id: i,
              ownerId: 1,
              categoryId: 1,
              title: "Θέμα "+i.toString(),
              date: DateTime.now(),
              text: "<u>Κείμενο <span style='color:rgb(1, 0, 0); font-size:18px;'>Θέματος</span> "+i.toString()+"</u>",
              views: 666
          )
      );
    }

    for (int i=manyTopics.length; i<3000; i++){
      manyTopics.add(
          new ForumTopic(
              id: i,
              ownerId: 2,
              categoryId: 2,
              title: "Θέμα "+i.toString(),
              date: DateTime.now(),
              text: "<u>Κείμενο <span style='color:rgb(1, 0, 1); font-size:18px;'>Θέματος</span> "+i.toString()+"</u>",
              views: 666
          )
      );
    }

    return manyTopics;
  }

  static List<ForumReply> forumReplies = [
    new ForumReply(
        topicId: 0,
        id: 0,
        ownerId: 2,
        date: DateTime.now(),
        text: "Kala ta les mastora",
        views: 166
    ),
    new ForumReply(
        topicId: 0,
        id: 1,
        ownerId: 5,
        date: DateTime.now(),
        text: "Siga re",
        views: 166
    ),
  ];

}