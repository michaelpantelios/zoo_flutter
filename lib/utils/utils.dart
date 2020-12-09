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

  getNiceDate(int timeInSecs){
    DateTime niceDate = DateTime.fromMillisecondsSinceEpoch(timeInSecs * 1000);
    return niceDate.day.toString() + " / " + niceDate.month.toString() + " / " + niceDate.year.toString();
  }

  getNiceDuration(BuildContext context, int durationInMins){
    String niceDuration;
    int hours = (durationInMins~/60);
    int mins = durationInMins - (hours*60);
    if(hours == 0)
      niceDuration = mins.toString()	+ " " + ( mins == 1 ? AppLocalizations.of(context).translate("app_profile_min") :  AppLocalizations.of(context).translate("app_profile_mins") );
    else
      niceDuration = hours.toString()	+ " " + ( hours == 1 ? AppLocalizations.of(context).translate("app_profile_hour") :  AppLocalizations.of(context).translate("app_profile_hours") ) +
    " " + AppLocalizations.of(context).translate("app_profile_and") + " " + mins.toString()	+ " " + ( mins == 1 ? AppLocalizations.of(context).translate("app_profile_min") :  AppLocalizations.of(context).translate("app_profile_mins") );

    return niceDuration;
  }

  getCountriesNames(BuildContext context){
    return AppLocalizations.of(context).translate("countries").split(",");
  }

  windowURL() {
    return Uri.parse(window.location.toString());
  }
}
