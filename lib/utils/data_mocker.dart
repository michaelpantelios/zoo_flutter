import 'package:flutter/material.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/models/user/user_main_photo.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';

class DataMocker {
  DataMocker._privateConstructor();

  static final DataMocker _instance = DataMocker._privateConstructor();

  static DataMocker get instance {
    return _instance;
  }

  //users

  static List<UserInfo> users = [
    new UserInfo(userId: 1001, level: 69, lastLogin: "2/4/2020", username: "Mitsos", coins: 1000, sex: 1, star: 1, city: "Αθήνα", mainPhoto: MainPhoto(width: "0", height: "0", id: "0", imageId: Env.getImageKitURL("2c98e7fa0f909d062de8549d9a7dfc33.png"))),
    new UserInfo(
      userId: 1000,
      lastLogin: "3/4/2020",
      username: "Mixos",
      coins: 1000,
      sex: 0,
      city: "Τρίκαλα",
    ),
    new UserInfo(
      userId: 1234,
      lastLogin: "3/4/2020",
      username: "Manolis",
      coins: 1000,
      sex: 0,
      city: "Τρίκαλα",
    ),
    new UserInfo(
      userId: 4566,
      lastLogin: "3/4/2020",
      username: "Poutsaklis",
      coins: 1000,
      sex: 0,
      city: "Τρίκαλα",
    ),
    new UserInfo(
      userId: 48383,
      lastLogin: "3/4/2020",
      username: "Johnys",
      coins: 1000,
      sex: 0,
      city: "Τρίκαλα",
    ),
    new UserInfo(
      userId: 4831111183,
      lastLogin: "3/4/2020",
      username: "Mitrousis",
      coins: 1000,
      sex: 0,
      city: "Τρίκαλα",
    )
  ];

  static List<ProfileInfo> fakeProfiles = [
    new ProfileInfo(status: "Hi", user: DataMocker.users[0], age: 12, country: 1, city: "a", zodiacSign: 1, online: "1", createDate: "1/2/2020", lastLogin: "1/2/2020", onlineTime: 3, level: 4, counters: CounterInfo(photos: 2, videos: 4, trophies: 7, friends: 8, gifts: 11)),
    new ProfileInfo(status: "Hi there", user: DataMocker.users[1], age: 22, country: 3, city: "b", zodiacSign: 1, online: "1", createDate: "1/2/2020", lastLogin: "1/2/2020", onlineTime: 7, level: 9, counters: CounterInfo(photos: 55, videos: 33, trophies: 44, friends: 56, gifts: 11)),
    new ProfileInfo(status: "Hi there", user: DataMocker.users[2], age: 22, country: 3, city: "b", zodiacSign: 1, online: "1", createDate: "1/2/2020", lastLogin: "1/2/2020", onlineTime: 7, level: 9, counters: CounterInfo(photos: 55, videos: 33, trophies: 44, friends: 56, gifts: 11)),
    new ProfileInfo(status: "Hi there", user: DataMocker.users[3], age: 22, country: 3, city: "b", zodiacSign: 1, online: "1", createDate: "1/2/2020", lastLogin: "1/2/2020", onlineTime: 7, level: 9, counters: CounterInfo(photos: 55, videos: 33, trophies: 44, friends: 56, gifts: 11)),
    new ProfileInfo(status: "Hi there", user: DataMocker.users[4], age: 22, country: 3, city: "b", zodiacSign: 1, online: "1", createDate: "1/2/2020", lastLogin: "1/2/2020", onlineTime: 7, level: 9, counters: CounterInfo(photos: 55, videos: 33, trophies: 44, friends: 56, gifts: 11)),
    new ProfileInfo(status: "Hi there", user: DataMocker.users[5], age: 22, country: 3, city: "b", zodiacSign: 1, online: "1", createDate: "1/2/2020", lastLogin: "1/2/2020", onlineTime: 7, level: 9, counters: CounterInfo(photos: 55, videos: 33, trophies: 44, friends: 56, gifts: 11)),
  ];

  static Map<String, int> getDays(BuildContext context) {
    Map<String, int> days = new Map<String, int>();
    days["--"] = -1;
    for (int i = 1; i <= 31; i++) {
      String label = i < 10 ? "0" + i.toString() : i.toString();
      days[label] = i;
    }

    return days;
  }

  static Map<String, int> getMonths(BuildContext context, {bool cut = false}) {
    List<String> monthStrings = AppLocalizations.of(context).translate("months").split(",");
    Map<String, int> months = new Map<String, int>();

    if (!cut) months["--"] = -1;

    for (int i = 0; i <= monthStrings.length - 1; i++) months[monthStrings[i]] = i + 1;

    return months;
  }

  static Map<String, int> getYears(BuildContext context) {
    Map<String, int> years = new Map<String, int>();
    int todayYear = new DateTime.now().year;

    years["--"] = -1;
    for (int i = todayYear - 18; i >= todayYear - 80; i--) years[i.toString()] = i;

    return years;
  }

  static Map<String, int> getAges(BuildContext context) {
    Map<String, int> ages = new Map<String, int>();
    ages["--"] = -1;

    for (int i = 18; i <= 80; i++) ages[i.toString()] = i;

    return ages;
  }

  static Map<String, int> getCountries(BuildContext context) {
    Map<String, int> countries = new Map<String, int>();
    List<String> countriesStrings = AppLocalizations.of(context).translate("countries").split(",");

    countries["--"] = -1;
    for (int i = 0; i <= countriesStrings.length - 1; i++) countries[countriesStrings[i]] = i;

    return countries;
  }

  static Map<String, int> getSexes(BuildContext context, {bool gen = false}) {
    List<String> sexStrings = AppLocalizations.of(context).translate("sexes1").split(",");
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

    distances[distanceStrings[3]] = -1;
    distances[distanceStrings[0]] = 1;
    distances[distanceStrings[1]] = 2;
    distances[distanceStrings[2]] = 3;

    return distances;
  }

  static Map<String, String> getOrder(BuildContext context) {
    Map<String, String> orders = new Map<String, String>();
    List<String> orderStrings = AppLocalizations.of(context).translate("orderBy").split(",");

    orders[orderStrings[0]] = "lastlogin";
    orders[orderStrings[1]] = "signup";

    return orders;
  }

  static Map<String, int> getZodiac(BuildContext context) {
    Map<String, int> zodiacs = new Map<String, int>();
    List<String> zodiacStrings = AppLocalizations.of(context).translate("zodiac").split(",");

    zodiacs["--"] = -1;

    for (int i = 1; i <= 12; i++) zodiacs[zodiacStrings[i - 1]] = i;

    return zodiacs;
  }

  static Map<String, int> getLookingFor(BuildContext context) {
    Map<String, int> looking = new Map<String, int>();
    List<String> lookingStrings = AppLocalizations.of(context).translate("lookingFor").split(",");

    looking[lookingStrings[0]] = 0;
    looking[lookingStrings[1]] = 1;
    looking[lookingStrings[2]] = 2;
    looking[lookingStrings[3]] = 4;

    return looking;
  }

  static Map<String, int> getPrefectures(BuildContext context) {
    Map<String, int> pref = new Map<String, int>();
    List<String> prefStrings = AppLocalizations.of(context).translate("prefectures").split(",");

    pref["--"] = 0;
    for (int i = 1; i <= 51; i++) pref[prefStrings[i - 1]] = i;

    return pref;
  }

  static List<String> countries = ["Ελλάδα", "Κύπρος", "Η.Π.Α.", "Γαλλία", "Ηνωμένο Βασίλειο"];

  static Map<String, String> premiumCoinsSMSSettings = {"smsCoinsGateway": "54754", "smsCoinsCost": "€1.49 / sms", "smsCoinsProvider": "Newsphone Hellas Α.Ε", "smsCoinsKeyword": "ZOO1"};

  static Map<String, String> premiumCoinsPhoneSettings = {
    "phoneCoinsProvider": "Newsphone Hellas Α.Ε",
    "phoneCoinsNumber": "50",
    "phoneCoinsGateway": "<span style='color: red'>90 11 00 13 01</span>",
    "phoneCoinsFixedCost": "€2,60/1' συμ/νου ΦΠΑ",
    "phoneCoinsCellCost": "€3,12/1' συμ/νου ΦΠΑ",
  };

  static Map<String, String> premiumStarSMSSettings = {
    "smsStarGateway": "54754",
    "smsStarCost": "€1.49 / sms",
    "smsStarProvider": "Newsphone Hellas Α.Ε",
    "smsStarKeyword": "ZOO1",
  };

  static Map<String, String> premiumStarPhoneSettings = {"phoneStarDays": "5", "phoneStarGateway": "<span style='color: red'>90 11 90 31 30</span>", "phoneStarFixedCost": "€2.60 / κλήση", "phoneStarCellCost": "€2.71 / κλήση", "phoneStarProvider": "Newsphone Hellas Α.Ε"};
}
