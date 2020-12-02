import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:zoo_flutter/apps/profile/profile.dart';
import 'package:zoo_flutter/apps/search/search.dart';
import 'package:zoo_flutter/apps/browsergames/browsergames.dart';
import 'package:zoo_flutter/apps/singleplayergames/single_player_games.dart';

import 'package:zoo_flutter/models/apps/app_info_model.dart';
import 'package:zoo_flutter/apps/home/models/home_module_info_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_topic_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_reply_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_category_model.dart';
import 'package:zoo_flutter/models/user/user_info_model.dart';

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
      appWidget: Search()
    ),
    "profile": new AppInfoModel(
      appId: "profile",
      appName: "app_name_profile",
      appType: AppType.popup,
      iconPath: Icons.account_box,
      appWidget: Profile(),
      size: new Size(600, 650)
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
    "browsergames" : new AppInfoModel(
      appId:"browsergames",
      appName:"app_name_browsergames",
      appType:AppType.full,
      iconPath: FontAwesomeIcons.rocket,
      appWidget:BrowserGames()
    ),
    "singleplayergames" : new AppInfoModel(
        appId:"singleplayergames",
        appName:"app_name_singleplayergames",
        appType:AppType.full,
        iconPath: FontAwesomeIcons.pastafarianism,
        appWidget:SinglePlayerGames()
    )
  };

  //users

  static List<UserInfoModel> users = [
    new UserInfoModel(userId: 0, isOnline: true, zooLevel: 69, signupDate: "1/1/2020", lastLogin: "2/4/2020", onlineTime: "1 ώρα", username: "Mitsos", zodiac: "Ζυγός",  quote: "YOLO", coins: 1000,  sex: 1, star: true, age: 40, city: "Αθήνα", country: "Ελλάδα", photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/2c98e7fa0f909d062de8549d9a7dfc33.png"),
    new UserInfoModel(userId: 1, isOnline: true, zooLevel: 13, signupDate: "1/1/2020", lastLogin: "3/4/2020", onlineTime: "2 ώρες", username: "Mixos", zodiac: "Υδροχόος", quote: "", coins: 1000, sex: 0, star: true, age: 40, city: "Τρίκαλα", country: "Ελλάδα", ),
    new UserInfoModel(userId: 2, isOnline: true, zooLevel: 55, signupDate: "1/1/2020", lastLogin: "4/4/2020", onlineTime: "3 ώρες", username: "Yannos", zodiac: "Λέων", quote: "Αυτά καλό είναι να μη γίνονται", coins: 10, sex: 0, star: false, age: 40, city: "Θεσσαλονίκη", country: "Ελλάδα", photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/1a65108a6db3a4ec545f006233c53a31.png"),
    new UserInfoModel(userId: 3, isOnline: false, zooLevel: 90, signupDate: "1/1/2020", lastLogin: "5/4/2020", onlineTime: "4 ώρες", username: "Giorgos", zodiac: "Κριός", quote: "Shit happens", coins: 1000, sex: 0, star: true, age: 40, city: "Κόρινθος", country: "Ελλάδα", photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/d510d643afae021c4e1dbc7ce1eb3f0a.png"),
    new UserInfoModel(userId: 4, isOnline: true, zooLevel: 4, signupDate: "1/1/2020", lastLogin: "6/7/2020", onlineTime: "5 ώρες", username: "Stefan", zodiac: "Δίδυμοι", quote: "check the fucking PSD", coins: 3000, sex: 0, star: false, age: 40, city: "Λαμία", country: "Ελλάδα"),
    new UserInfoModel(userId: 5, isOnline: true, zooLevel: 23, signupDate: "1/1/2020", lastLogin: "7/8/2020", onlineTime: "7 ώρες", username: "Stellakrou", zodiac: "Ταύρος",  quote: "Έρχομαι από κει", coins: 2000, sex: 1, star: true, age: 40, city: "Ηράκλειο", country: "Ελλάδα"),
    new UserInfoModel(userId: 6, isOnline: true, zooLevel: 88, signupDate: "1/1/2020", lastLogin: "8/8/2020", onlineTime: "8 ώρες", username: "Violeta", zodiac: "Ζυγός", quote: "Πάρε με τώρα", coins: 0, sex: 1, age: 40, star: false, city: "Πάτρα", country: "Ελλάδα"),
    new UserInfoModel(userId: 7, isOnline: false, zooLevel: 120, signupDate: "1/1/2020", lastLogin: "8/3/2020", onlineTime: "9 ώρες", username: "Popara", zodiac: "Τοξότης", quote: "Στη σηκώνω και με καρφώνεις", coins: 34, sex: 2, age: 40, star: true, city: "Καλαμάτα", country: "Ελλάδα", photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/237e51c6142589e9333258ebda2f2f09.png"),
    new UserInfoModel(userId: 8, isOnline: true, zooLevel: 2, signupDate: "1/1/2020", lastLogin: "6/6/2020", onlineTime: "10 ώρες", username: "Mixalios", zodiac: "Αιγόκερως", quote: "Life is strange", coins: 0, sex: 0, age: 40, star: false, city: "Κέρκυρα", country: "Ελλάδα" ),
    new UserInfoModel(userId: 9, isOnline: false, zooLevel: 77, signupDate: "1/1/2020", lastLogin: "2/2/2020", onlineTime: "11 ώρες", username: "Kavlikos", zodiac: "Καρκίνος", quote: "Violet για πάντα", coins: 1000, sex: 1, age: 40, star: true, city: "Λάρισα", country: "Ελλάδα" ),
    new UserInfoModel(userId: 10, isOnline: true, zooLevel: 9, signupDate: "1/1/2020", lastLogin: "2/9/2020", onlineTime: "12 ώρες", username: "SouziTsouzi", zodiac: "Τοξότης", quote: "Πιο μαλακά μαλάκα !", coins: 1000, sex: 2, age: 40,  star: true,city: "Χανιά", country: "Ελλάδα", photoUrl: "https://ik.imagekit.io/bugtown/userphotos/testing/b643ff5523c29138a9efafa271599a27.png")
  ];

  static Map<String, int> getDays(BuildContext context){
    Map<String, int> days = new Map<String, int>();
    days["--"] = -1;
    for (int i=1; i<=31; i++){
      String label = i < 10 ? "0" + i.toString() : i.toString();
      days[label] = i;
    }

    return days;
  }

  static Map<String, int> getMonths(BuildContext context, {bool cut = false}){
    List<String> monthStrings = AppLocalizations.of(context).translate("months").split(",");
    Map<String, int> months = new Map<String, int>();

    if (!cut)
      months["--"] = -1;

    for (int i = 0; i<=months.length - 1; i++)
      months[monthStrings[i]] =  i + 1;

    return months;
  }

  static Map<String, int>  getYears( BuildContext context ){
    Map<String, int> years = new Map<String, int>();
    int todayYear = new DateTime.now().year;

    years["--"] = -1;
    for (int i = todayYear - 18; i >= todayYear - 80; i--)
      years[i.toString()] = i;

    return years;
  }

  static Map<String, int> getAges( BuildContext context ){
    Map<String, int> ages = new Map<String, int>();
    ages["--"] = -1;

    for (int i=18; i<=80; i++)
      ages[i.toString()] = i;

    return ages;
  }

  static Map<String, int> getCountries( BuildContext context ){
    Map<String, int> countries = new Map<String, int>();
    List<String> countriesStrings = AppLocalizations.of(context).translate("countries").split(",");

    countries["--"] = -1;
    for (int i=0; i<=countriesStrings.length-1; i++)
      countries[ countriesStrings[i] ] = i;

    return countries;
  }

  static Map<String, int> getSexes(BuildContext context, {bool gen = false}){
    List<String> sexStrings = AppLocalizations.of(context).translate("sexes").split(",");
    Map<String, int> sexes = new Map<String, int>();

      sexes["--"] = -1;
      sexes[sexStrings[0]] = 1;
      sexes[sexStrings[1]] = 2;
      sexes[sexStrings[2]] = 4;

      return sexes;
   }

  static Map<String, int> getDistanceFromMe(BuildContext context) {
  Map<String, int> distances = new Map<String, int>();
  List<String> distanceStrings = AppLocalizations.of(context).translate("distanceFromMe").split(",");

    distances[distanceStrings[0]] = 1;
    distances[distanceStrings[1]] = 2;
    distances[distanceStrings[2]] = 3;
    distances[distanceStrings[3]] = 0;

    return distances;
  }

  static Map<String, String> getOrder(BuildContext context) {
    Map<String, String> orders = new Map<String, String>();
    List<String> orderStrings = AppLocalizations.of(context).translate("orderBy").split(",");

    orders[orderStrings[0]] = "lastlogin";
    orders[orderStrings[1]] = "signup";

    return orders;
  }

  static Map<String, int> getZodiac(BuildContext context){
    Map<String, int> zodiacs = new Map<String, int>();
    List<String> zodiacStrings = AppLocalizations.of(context).translate("zodiac").split(",");

    zodiacs["--"] = -1;

    for (int i = 1; i<=12; i++)
      zodiacs[zodiacStrings[i-1]] = i;

    return zodiacs;
  }

  static Map<String, int> getLookingFor(BuildContext context){
    Map<String, int> looking = new Map<String, int>();
    List<String> lookingStrings = AppLocalizations.of(context).translate("lookingFor").split(",");

    looking[lookingStrings[0]] = 0;
    looking[lookingStrings[1]] = 1;
    looking[lookingStrings[2]] = 2;
    looking[lookingStrings[3]] = 4;

    return looking;
  }

  static Map<String, int> getPrefectures(BuildContext context){
    Map<String, int> pref = new Map<String, int>();
    List<String> prefStrings = AppLocalizations.of(context).translate("prefectures").split(",");

    pref["--"] = 0;
    for (int i=1; i<=51; i++)
      pref[prefStrings[i-1]] = i;

    return pref;
  }


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