import 'package:flutter/material.dart';

import 'package:zoo_flutter/apps/forum/forum.dart';
import 'package:zoo_flutter/apps/login/login.dart';
import 'package:zoo_flutter/apps/messenger/messenger_chat.dart';
import 'package:zoo_flutter/apps/home/home.dart';
import 'package:zoo_flutter/apps/multigames/multigames.dart';
import 'package:zoo_flutter/apps/coins/coins.dart';
import 'package:zoo_flutter/apps/star/star.dart';
import 'package:zoo_flutter/apps/chat/chat.dart';
import 'package:zoo_flutter/apps/signup/signup.dart';
import 'package:zoo_flutter/apps/privatechat/private_chat.dart';
import 'package:zoo_flutter/apps/photos/photos.dart';
import 'package:zoo_flutter/apps/photos/photo_file_upload.dart';
import 'package:zoo_flutter/apps/photos/photo_camera_upload.dart';
import 'package:zoo_flutter/apps/videos/videos.dart';
import 'package:zoo_flutter/apps/settings/settings.dart';

import 'package:zoo_flutter/models/apps/app_info_model.dart';
import 'package:zoo_flutter/models/home/home_module_info_model.dart';
import 'package:zoo_flutter/models/forum/forum_topic_model.dart';
import 'package:zoo_flutter/models/forum/forum_reply_model.dart';
import 'package:zoo_flutter/models/forum/forum_category_model.dart';
import 'package:zoo_flutter/models/user/user_info_model.dart';
import 'package:zoo_flutter/models/multigames/multigame_data_model.dart';

 enum appIds  {home, chat, forum, games, search, profile, star, coins, messenger, notifications, settings}

class DataMocker {
  DataMocker._privateConstructor();

  static final DataMocker _instance = DataMocker._privateConstructor();

  static DataMocker get instance {
    return _instance;
  }

  //apps

  static Map<String, AppInfoModel> apps = {
    "home" : new AppInfoModel(
      appId: "home",
      appName: "app_name_home",
      appType: AppType.full,
      iconPath: Icons.home_filled,
      appWidget: Home()
    ),
    "chat" : new AppInfoModel(
      appId: "chat",
      appName: "app_name_chat",
      appType: AppType.full,
      iconPath: Icons.chat_bubble,
      appWidget: Chat()
    ),
    "forum" : new AppInfoModel(
      appId: "forum",
      appName: "app_name_forum",
      appType: AppType.full,
      iconPath: Icons.notes,
      appWidget: Forum()
    ),
    "multigames" : new AppInfoModel(
      appId: "multigames",
      appName: "app_name_multigames",
      appType: AppType.full,
      iconPath: Icons.casino,
      appWidget: Multigames()
    ),
    "search" : new AppInfoModel(
      appId: "search",
      appName: "app_name_search",
      appType: AppType.full,
      iconPath: Icons.search,
      appWidget: Container()
    ),
    "profile": new AppInfoModel(
      appId: "profile",
      appName: "app_name_profile",
      appType: AppType.popup,
      iconPath: Icons.account_box,
      appWidget: Container()
    ),
    "star": new AppInfoModel(
      appId: "star",
      appName: "app_name_star",
      appType: AppType.popup,
      iconPath: Icons.star,
      appWidget: Star(),
      size: new Size(700, 650)
    ),
    "coins": new AppInfoModel(
      appId: "coins",
      appName: "app_name_coins",
      appType: AppType.popup,
      iconPath: Icons.copyright,
      appWidget: Coins(),
      size: new Size(600,650)
    ),
    "messenger": new AppInfoModel(
      appId: "messenger",
      appName: "app_name_messenger",
      appType: AppType.full,
      iconPath: Icons.comment,
      appWidget: Container()
    ),
    "notificationsDropdown": new AppInfoModel(
      appId: "notificationsDropdown",
      appName: "app_name_notificationsDropdown",
      appType: AppType.dropdown,
      iconPath: Icons.notifications,
      appWidget: Container()
    ),
    "settingsDropdown": new AppInfoModel(
      appId: "settingsDropdown",
      appName: "app_name_settings",
      appType: AppType.popup,
      iconPath: Icons.settings,
      appWidget: Container()
    ),
    "settings" : new AppInfoModel(
        appId: "settings",
        appName: "app_name_settings",
        appType: AppType.popup,
        iconPath: Icons.settings,
        appWidget: Settings(),
        size: new Size(650, 400)
    ),
    "privateChat": new AppInfoModel(
      appId: "privateChat",
      appName: "app_name_privateChat",
      appType: AppType.full,
      iconPath:Icons.chat_bubble,
      appWidget: PrivateChat()
    ),
    "login" : new AppInfoModel(
      appId: "login",
      appName: "app_name_login",
      appType: AppType.popup,
      iconPath:Icons.login,
      appWidget: Login(),
      size: new Size(600, 410)
    ),
    "signup" : new AppInfoModel(
      appId:"signup",
      appName:"app_name_signup",
      appType: AppType.popup,
      iconPath: Icons.edit,
      appWidget: Signup(),
      size: new Size(600,460)
    ),
    "messengerChat": new AppInfoModel(
        appId:"messengerChat",
        appName:"app_name_messengerChat",
        appType: AppType.popup,
        iconPath: Icons.chat_bubble,
        appWidget: MessengerChat(),
        size: new Size(600,460)
    ),
    "photos" : new AppInfoModel(
        appId:"photos",
        appName:"app_name_photos",
        appType: AppType.popup,
        iconPath: Icons.photo_camera,
        appWidget: Photos(),
        size: new Size(600,400)
    ),
    "photoFileUpload" : new AppInfoModel(
        appId:"photosFileUpload",
        appName:"app_name_photo_file_upload",
        appType: AppType.popup,
        iconPath: Icons.add_photo_alternate_outlined,
        appWidget: PhotoFileUpload(),
        size: new Size(500,205)
    ),
    "photoCameraUpload" : new AppInfoModel(
        appId:"photosCameraUpload",
        appName:"app_name_photo_camera_upload",
        appType: AppType.popup,
        iconPath: Icons.linked_camera,
        appWidget: PhotoCameraUpload(),
        size: new Size(400,600)
    ),
    "videos" : new AppInfoModel(
        appId:"videos",
        appName:"app_name_videos",
        appType: AppType.popup,
        iconPath: Icons.video_collection,
        appWidget: Videos(),
        size: new Size(650,500)
    ),
  };

  //users

  static List<UserInfoModel> users = [
    new UserInfoModel(userId: 0, username: "Mitsos", coins: 1000,  sex: 0, star: true, age: 40, city: "Αθήνα", country: "Ελλάδα", photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/2c98e7fa0f909d062de8549d9a7dfc33.png"),
    new UserInfoModel(userId: 1, username: "Mixos", coins: 1000, sex: 0, star: true, age: 40, city: "Τρίκαλα", country: "Ελλάδα", ),
    new UserInfoModel(userId: 2, username: "Yannos", coins: 10, sex: 0, star: false, age: 40, city: "Θεσσαλονίκη", country: "Ελλάδα", photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/1a65108a6db3a4ec545f006233c53a31.png"),
    new UserInfoModel(userId: 3, username: "Giorgos", coins: 1000, sex: 0, star: true, age: 40, city: "Κόρινθος", country: "Ελλάδα", photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/d510d643afae021c4e1dbc7ce1eb3f0a.png"),
    new UserInfoModel(userId: 4, username: "Stefan", coins: 3000, sex: 0, star: false, age: 40, city: "Λαμία", country: "Ελλάδα"),
    new UserInfoModel(userId: 5, username: "Stellakrou", coins: 2000, sex: 1, star: true, age: 40, city: "Ηράκλειο", country: "Ελλάδα"),
    new UserInfoModel(userId: 6, username: "Violeta", coins: 0, sex: 1, age: 40, star: false, city: "Πάτρα", country: "Ελλάδα"),
    new UserInfoModel(userId: 7, username: "Popara", coins: 34, sex: 1, age: 40, star: true, city: "Καλαμάτα", country: "Ελλάδα", photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/237e51c6142589e9333258ebda2f2f09.png"),
    new UserInfoModel(userId: 8, username: "Mixalios", coins: 0, sex: 0, age: 40, star: false, city: "Κέρκυρα", country: "Ελλάδα" ),
    new UserInfoModel(userId: 9, username: "Kavlikos", coins: 1000, sex: 0, age: 40, star: true, city: "Λάρισα", country: "Ελλάδα" ),
    new UserInfoModel(userId: 10, username: "SouziTsouzi", coins: 1000, sex: 1, age: 40,  star: true,city: "Χανιά", country: "Ελλάδα", photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/b643ff5523c29138a9efafa271599a27.png")
  ];

  //home app

  static List<HomeModuleInfoModel> homeModules = [
    new HomeModuleInfoModel(
      title: "Το νέο Zoo.gr είναι γεγονός!",
      mainText: "Η νέα σύνθεση του Zoo.gr με μπλε και πράσινους κόκκους εξαφανίζει τη βαρεμάρα και τη μοναξιά. Τώρα, στο zoo.gr θα βγάλετε γκόμενα, τα απωθημένα σας, και ό,τι άλλο γουστάρετε!",
      position: ModulePosition.left
    ),
    new HomeModuleInfoModel(
      title: "H Violet σε περιμένει...",
      imagePath: "images/home/violets.jpg",
      position: ModulePosition.middle
    ),
    new HomeModuleInfoModel(
      title: "Νέο παιχνίδι στο zoo.gr!",
      imagePath: "images/home/yatzy.png",
      mainText: "Το καινούριο Yatzy τα σπάει μιλάμε",
      position: ModulePosition.right
    )
  ];

  //forum app
  static List<ForumCategoryModel> forumCategories = [
    new ForumCategoryModel(id: 0, name: "Καφενείο"),
    new ForumCategoryModel(id: 1, name: "Σχέσεις"),
    new ForumCategoryModel(id: 2, name: "Τεχνολογία"),
    new ForumCategoryModel(id: 3, name: "Αθλητικά"),
    new ForumCategoryModel(id: 4, name: "Πολιτική"),
    new ForumCategoryModel(id: 5, name: "Φιλοσοφία"),
    new ForumCategoryModel(id: 6, name: "Τέχνες"),
    new ForumCategoryModel(id: 7, name: "AutoMoto")
  ];

  static List<ForumTopicModel> forumTopics = [
    new ForumTopicModel(
        id: 0,
        ownerId: 0,
        categoryId: 1,
        title: "Gia ola ftaine oi gomenes",
        date: DateTime.now(),
        text: "... oi prwin ki oi epomenes... ",
        views: 666
    ),
    new ForumTopicModel(
        id: 1,
        ownerId: 2,
        categoryId: 0,
        title: "Covid-19",
        date: DateTime.now(),
        text: "Araiwnete!",
        views: 666
    ),
    new ForumTopicModel(
        id: 2,
        ownerId: 2,
        categoryId: 0,
        title: "Bastate Tourkoi t'aloga",
        date: DateTime.now(),
        text: "Kalos tourkos einai o nekros tourkos!",
        views: 666
    ),
    new ForumTopicModel(
        id: 3,
        ownerId: 3,
        categoryId: 2,
        title: "Nees texnologies",
        date: DateTime.now(),
        text: "To flutter einai to kalytero",
        views: 666
    ),
    new ForumTopicModel(
        id: 4,
        ownerId: 5,
        categoryId: 0,
        title: "Pws sas fainetai to neo zoo?",
        date: DateTime.now(),
        text: "Gamaei!",
        views: 666
    )
  ];

  List<ForumTopicModel> getManyTopics() {
    List<ForumTopicModel> manyTopics = new List<ForumTopicModel>();

    for (int i=0; i<1000; i++){
      manyTopics.add(
          new ForumTopicModel(
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
          new ForumTopicModel(
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
          new ForumTopicModel(
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

  static List<ForumReplyModel> forumReplies = [
    new ForumReplyModel(
        topicId: 0,
        id: 0,
        ownerId: 2,
        date: DateTime.now(),
        text: "Kala ta les mastora",
        views: 166
    ),
    new ForumReplyModel(
        topicId: 0,
        id: 1,
        ownerId: 5,
        date: DateTime.now(),
        text: "Siga re",
        views: 166
    ),
  ];

  static List<String> chatWelcomeMessages = [
    "Παρακαλούμε, διαβάστε τους ακόλουθους κανόνες πριν κάνετε χρήση του chat:",
    "1. Απαγορεύεται η αποστολή εξωτερικών διευθύνσεων (εκτός YouTube) και οποιασδήποτε μορφής διαφήμισης, δυσφήμησης ή αγγελιών.:",
    "2. Απαγορεύονται οποιουδήποτε είδους προσβλητικές, χυδαίες, ρατσιστικές εκφράσεις ή να χρησιμοποιείτε το chat για την αποστολή οποιουδήποτε είδους παράνομου περιεχομένου. ",
    "3. Απαγορεύεται το Flooding.",
    "4. Δεν επιτρέπεται στο chat να γράφετε τηλέφωνα, emails ή οποιαδήποτε άλλα προσωπικά στοιχεία.",
    "5. Δεν επιτρέπεται να εμφανίζετε prive συνομιλίες στο public room με σκοπό να αποδείξετε ότι κάποιος άλλος χρήστης παραβαίνει τους κανόνες λειτουργίας. Οι operators ελέγχουν μόνο τις συνομιλίες στο public. Αν θέλετε να αποκλείσετε την prive συνομιλία με οποιονδήποτε χρήστη και για οποιοδήποτε λόγο, μπορείτε να κάνετε χρήση του ignore.",
    "6. Το Zoo.gr διατηρεί το δικαίωμα να καταργήσει operators ή chatmasters για οποιοδήποτε λόγο.",
    "Καλή διασκέδαση!"
  ];

  static List<String> fixedChatMessages = [
    "Δεν υπάρχει covid",
    "Είναι όλα σινομοσύα",
    "Ζήτω η 28η Οκτωβρίου",
    "Ελάτε να τα πάρετε",
    "Μολών Λαβέ",
    "Τουρκόσποροι θα πεθάνετε",
    "Κανένα γκομενάκι για κουβεντούλα",
    "Τον έχω 50εκ",
    "Ζήτω το έθνος",
    "Ζήτω το ΟΧΙ",
    "ΦΤΟΥ ΣΚΟΥΛΗΚΟΜΥΡΜΗΓΚΟΤΡΥΠΑ",
    "Ασπρη πέτρα ξέξασπρη",
    "Δεν βγαίνει νόημα από όλο αυτό",
    "Μία φούντωση, μια φλόγα έχω μέσα στην καρδιά λες και μάγια μου 'χεις κάνει Φραγκοσυριανή γλυκιά λες και μάγια μου 'χεις κάνει Φραγκοσυριανή γλυκιά"
  ];

  static List<Color> fixedChatMessageColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.pink,
    Colors.orange,
    Colors.black,
    Colors.purple
  ];

  static List<String> countries = [
    "Ελλάδα",
    "Κύπρος",
    "Η.Π.Α.",
    "Γαλλία",
    "Ηνωμένο Βασίλειο"
  ];

  static List<MultigameDataModel> multigames = [
    new MultigameDataModel(id: "agonia", iconUrl: "agonia_logo", name: "Αγωνία"),
    new MultigameDataModel(id: "kseri", iconUrl: "kseri_logo", name: "Ξερή"),
    new MultigameDataModel(id: "backgammon", iconUrl: "backgammon_logo", name: "Τάβλι"),
    new MultigameDataModel(id: "mahjong", iconUrl: "mahjong_logo", name: "Mahjong Duels"),
    new MultigameDataModel(id: "wordfight", iconUrl: "wordfight_logo", name: "Λεξοκόντρες"),
    new MultigameDataModel(id: "yatzy_duels", iconUrl: "yatzy_logo", name: "Yatzy Duels")
  ];

  static Map<String, String> premiumCoinsSMSSettings = {
    "smsCoinsGateway"		: "54754",
    "smsCoinsCost"		: "€1.49 / sms",
    "smsCoinsProvider"	: "Newsphone Hellas Α.Ε",
    "smsCoinsKeyword"		: "ZOO1"
  };

  static Map<String, String> premiumCoinsPhoneSettings = {
    "phoneCoinsProvider"	: "Newsphone Hellas Α.Ε",
    "phoneCoinsNumber"	: "80",
    "phoneCoinsGateway"	: "90 11 00 13 01",
    "phoneCoinsFixedCost"	: "€2,60/1' συμ/νου ΦΠΑ",
    "phoneCoinsCellCost"	: "€3,12/1' συμ/νου ΦΠΑ",
  };

  static Map<String, String> premiumStarSMSSettings = {
    "smsStarGateway" : "54754",
    "smsStarCost"	: "€1.49 / sms",
    "smsStarProvider"	: "Newsphone Hellas Α.Ε",
    "smsStarKeyword": "ZOO1",
  };

  static Map<String, String> premiumStarPhoneSettings = {
    "phoneStarDays"		: "5",
    "phoneStarGateway"	: "90 11 90 31 30",
    "phoneStarFixedCost"	: "€2.60 / λεπτό",
    "phoneStarCellCost"	: "€2.71 / λεπτό",
    "phoneStarProvider"	: "Newsphone Hellas Α.Ε"
  };


}