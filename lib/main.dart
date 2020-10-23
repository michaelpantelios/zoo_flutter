import 'package:flutter/material.dart';

import 'package:zoo_flutter/theme/theme.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zoo_flutter/control/root_widget_main_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoo@Flutter',
      theme: appThemeData[AppTheme.Theme1],
      supportedLocales: [
        Locale('el', 'GR'),
      ],
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
//          return Locale('en', 'US');
        return Locale('el', 'GR');
      },
      home: Main(),
    );
  }
}
