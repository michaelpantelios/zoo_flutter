import 'package:flutter/material.dart';

import 'package:zoo_flutter/theme/theme.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:zoo_flutter/widgets/control_panel.dart';
import 'package:zoo_flutter/widgets/apps_area.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ControlPanel _panel;
  AppsArea _appsArea;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _panel = new ControlPanel();
    _appsArea = new AppsArea();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).accentColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _panel,
                  _appsArea
                ]
            )
          );
    }
}
