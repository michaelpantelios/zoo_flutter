import 'package:flutter/material.dart';

import 'package:zoo_flutter/theme/theme.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:zoo_flutter/panel/panel.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/widgets/apps_area.dart';
import 'package:zoo_flutter/containers/full_app_container.dart';

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

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  Panel _panel;
  FullAppContainer _appWindow;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _panel = new Panel();
    _appWindow = new FullAppContainer(appInfo : DataMocker.apps["home"]);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _panel,
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: _appWindow
                    )
                  )
                ]
            )
          );
    }
}
