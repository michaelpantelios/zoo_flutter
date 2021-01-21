import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

import 'env.dart';

class Utils {
  Utils._privateConstructor();

  static final Utils _instance = Utils._privateConstructor();

  static Utils get instance {
    return _instance;
  }

  static final String oldZoo = "https://www.zoo.gr/?version=flash";
  static final String helpUrl = "https://support.zoo.gr/";
  static final String userTerms = "https://support.zoo.gr/047341-%CE%8C%CF%81%CE%BF%CE%B9-%CE%A7%CF%81%CE%AE%CF%83%CE%B7%CF%82";
  static final String privacyTerms = "https://support.zoo.gr/177391-%CE%A0%CE%BF%CE%BB%CE%B9%CF%84%CE%B9%CE%BA%CE%AE-%CE%A0%CF%81%CE%BF%CF%83%CF%84%CE%B1%CF%83%CE%AF%CE%B1%CF%82-%CE%A0%CF%81%CE%BF%CF%83%CF%89%CF%80%CE%B9%CE%BA%CF%8E%CE%BD-%CE%94%CE%B5%CE%B4%CE%BF%CE%BC%CE%AD%CE%BD%CF%89%CE%BD";
  static final String zooLevelHelp = "https://support.zoo.gr/134310-Zoo-Level";

  static final String userPhotosUri = "${Env.userPhotosHost}//images/%0/%1.jpg";
  static final String uploadPhotoUri = "${Env.cgiHost}/cgi/upload_file.pl?sessionKey=%0&filename=%1";
  static final String uploadVideoUri = "${Env.cgiHost}/cgi/videos/upload_file.pl?sessionKey=%0&id=%1;";

  getSexString(BuildContext context, int sex) {
    switch (sex) {
      case 0:
        return AppLocalizations.of(context).translate("user_sex_none");
      case 1:
        return AppLocalizations.of(context).translate("user_sex_male");
      case 2:
        return AppLocalizations.of(context).translate("user_sex_female");
      case 4:
        return AppLocalizations.of(context).translate("user_sex_couple");
    }
  }

  getUserPhotoUrl({String photoId, String size = "thumb"}) {
    return Utils.userPhotosUri.replaceAll("%0", size).replaceAll("%1", photoId);
  }

  getUploadPhotoUrl({String sessionKey, String filename}) {
    return Utils.uploadPhotoUri.replaceAll("%0", sessionKey).replaceAll("%1", filename);
  }

  getUploadVideoUrl({String sessionKey, String filename}) {
    return Utils.uploadVideoUri.replaceAll("%0", sessionKey).replaceAll("%1", filename);
  }

  randomDigitString() {
    DateTime a = DateTime.now();
    int uniqueID = (DateTime.utc(a.year, a.month, a.day, a.hour, a.minute, a.second, a.millisecond).millisecondsSinceEpoch / 1000).ceil();
    return uniqueID.toString();
  }

  getNiceDate(int timeInSecs) {
    DateTime niceDate = DateTime.fromMillisecondsSinceEpoch(timeInSecs * 1000);
    return niceDate.day.toString() + " / " + niceDate.month.toString() + " / " + niceDate.year.toString();
  }

  getNiceDateWithHours(BuildContext context, int timeInSecs) {
    DateTime niceDate = DateTime.fromMillisecondsSinceEpoch(timeInSecs * 1000);
    return niceDate.day.toString() + " " + AppLocalizations.of(context).translate("months").split(',')[int.parse(niceDate.month.toString()) - 1].substring(0, 3) + " " + niceDate.hour.toString() + ":" + niceDate.minute.toString();
  }

  getNiceForumDate({String dd, bool hours = true}) {
    if (hours)
      return dd.substring(6, 8) + "/" + dd.substring(4, 6) + "/" + dd.substring(0, 4) + " " + dd.substring(9, 14);
    else
      return dd.substring(6, 8) + "/" + dd.substring(4, 6) + "/" + dd.substring(0, 4);
  }

  getNiceDuration(BuildContext context, int durationInMins) {
    String niceDuration;
    int hours = (durationInMins ~/ 60);
    int mins = durationInMins - (hours * 60);
    if (hours == 0)
      niceDuration = mins.toString() + " " + (mins == 1 ? AppLocalizations.of(context).translate("app_profile_min") : AppLocalizations.of(context).translate("app_profile_mins"));
    else
      niceDuration = hours.toString() +
          " " +
          (hours == 1 ? AppLocalizations.of(context).translate("app_profile_hour") : AppLocalizations.of(context).translate("app_profile_hours")) +
          " " +
          AppLocalizations.of(context).translate("app_profile_and") +
          " " +
          mins.toString() +
          " " +
          (mins == 1 ? AppLocalizations.of(context).translate("app_profile_min") : AppLocalizations.of(context).translate("app_profile_mins"));

    return niceDuration;
  }

  getCountriesNames(BuildContext context) {
    return AppLocalizations.of(context).translate("countries").split(",");
  }

  windowURL() {
    return Uri.parse(window.location.toString());
  }

  String format(String value, List<String> rest) {
    for (var i = rest.length - 1; i >= 0; i--) {
      String restx = rest[i];

      if (restx == "<br/>") {
        value = value.replaceAll("<$i/>", restx);
      } else {
        List<String> f = restx.split("|");
        for (var j = 0; j <= f.length - 1; j++) value = value.replaceAll(j == 0 ? "<$i>" : "</$i>", f[j]);
      }
    }

    return value;
  }

  getHelpUrl() {
    return Utils.helpUrl;
  }

}
