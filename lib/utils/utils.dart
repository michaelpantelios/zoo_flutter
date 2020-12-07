import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class Utils {
  Utils._privateConstructor();

  static final Utils _instance = Utils._privateConstructor();

  static Utils get instance {
    return _instance;
  }

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

  windowURL() {
    return Uri.parse(window.location.toString());
  }
}
