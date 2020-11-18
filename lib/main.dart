import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/containers/full/full_app_container.dart';
import 'package:zoo_flutter/panel/panel.dart';
import 'package:zoo_flutter/providers/auth.dart';
import 'package:zoo_flutter/providers/users_counter.dart';
import 'package:zoo_flutter/theme/theme.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

bool _inited = false;

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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<UsersCounter>(
            create: (context) => UsersCounter(),
          ),
          ChangeNotifierProvider(
            create: (context) => Auth(),
          )
        ],
        child: Root(),
      ),
    );
  }
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!_inited) {
      _inited = true;
      Timer.periodic(Duration(milliseconds: 1000), (Timer t) {
        context.read<UsersCounter>().onChatUsers += 2;
      });

      Timer.periodic(Duration(milliseconds: 2000), (Timer t) {
        context.read<UsersCounter>().onGamesUsers += 3;
      });

      Timer.periodic(Duration(milliseconds: 4000), (Timer t) {
        context.read<UsersCounter>().onLineUsers += 4;
      });

      Future.delayed(Duration(milliseconds: 4000), () {
        print("user logged in.");
        context.read<Auth>().isLoggedIn = true;
        context.read<Auth>().username = "JohnyBeGood";
        context.read<Auth>().coins = 5;
      });
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                    child: FullAppContainer(appInfo: DataMocker.apps["chat"]),
                  ),
                )
              ],
            ),
          ),
          // PopupContainer(appInfo: DataMocker.apps["chat"])
        ],
      ),
    );
  }
}
