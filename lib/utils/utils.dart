import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class Utils {
  Utils._privateConstructor();

  static final Utils _instance = Utils._privateConstructor();

  static Utils get instance {
    return _instance;
  }

  static final String userPhotosUri = "https://img.zoo.gr//images/%0/%1.jpg";
  static final String uploadPhotoUri = "https://www.zoo.gr/cgi/upload_file.pl?sessionKey=%0&filename=%1";
  static final String uploadVideoUri = "https://www.zoo.gr/cgi/videos/upload_file.pl?sessionKey=%0&id=%1;";

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

  getUserPhotoUrl({String photoId, String size = "thumb"}){
    return Utils.userPhotosUri.replaceAll("%0", size).replaceAll("%1", photoId);
  }

  getUploadPhotoUrl({String sessionKey, String filename}){
    return Utils.uploadPhotoUri.replaceAll("%0", sessionKey).replaceAll("%1", filename);
  }

  getUploadVideoUrl({String sessionKey, String filename}) {
    return Utils.uploadVideoUri.replaceAll("%0", sessionKey).replaceAll("%1", filename);
  }

  randomDigitString(){
    DateTime a = DateTime.now();
    int uniqueID = (DateTime.utc(a.year, a.month, a.day, a.hour, a.minute, a.second,a.millisecond).millisecondsSinceEpoch / 1000).ceil();
    return uniqueID.toString();
  }

  getNiceDate(int timeInSecs){
    DateTime niceDate = DateTime.fromMillisecondsSinceEpoch(timeInSecs * 1000);
    return niceDate.day.toString() + " / " + niceDate.month.toString() + " / " + niceDate.year.toString();
  }

  getNiceForumDate({String dd, bool hours = true}) {
    if(hours)
      return dd.substring(6,8) + "/" + dd.substring(4,6) + "/" + dd.substring(0,4) + " " + dd.substring(9,14);
    else
      return dd.substring(6,8) + "/" + dd.substring(4,6) + "/" + dd.substring(0,4);
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
}
