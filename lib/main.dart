import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/containers/full/full_app_container.dart';
import 'package:zoo_flutter/containers/popup/popup_container.dart';
import 'package:zoo_flutter/panel/panel.dart';
import 'package:zoo_flutter/theme/theme.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

import 'providers/user_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => UserProvider(),
        )
      ],
      child: MaterialApp(
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
        home: Root(),
      ),
    );
  }
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      var app = DataMocker.apps["signup"];
      PopupContainer(
        context: context,
        app: app.appWidget,
        title: app.appName,
        size: app.size,
        titleBarIcon: app.iconPath,
      ).show();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Panel(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FullAppContainer(appInfo: DataMocker.apps["home"]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
