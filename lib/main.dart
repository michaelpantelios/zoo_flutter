import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/multigames/multigames.dart';
import 'package:zoo_flutter/containers/full/full_app_container_bar.dart';
import 'package:zoo_flutter/panel/panel.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/notifications_provider.dart';
import 'package:zoo_flutter/theme/theme.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/env.dart';

import 'providers/user_provider.dart';

final Map envSettings = {"testing": false};

void main() {
  new Env(envSettings);
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
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => AppProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => NotificationsProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => AppBarProvider(),
        ),
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
  Map<AppType, dynamic> _allAppsWithShortcuts;
  List<Widget> _loadedApps;

  @override
  void initState() {
    _allAppsWithShortcuts = Map<AppType, dynamic>();
    var index = 0;
    AppType.values.forEach((app) {
      var appInfo = AppProvider.instance.getAppInfo(app);
      if (appInfo.hasPanelShortcut && appInfo.id != AppType.Multigames) {
        _allAppsWithShortcuts[appInfo.id] = {
          "app": AppProvider.instance.getAppWidget(app, context),
          "index": index,
        };
        index++;
      }
    });

    _loadedApps = [];
    _allAppsWithShortcuts.keys.forEach((key) {
      _loadedApps.add(Container());
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
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(3.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: _barAndFullApp(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _barAndFullApp(BuildContext context) {
    var currentAppIndex;
    var currentAppID;
    var currentApp;
    var appInfo = context.watch<AppProvider>().currentAppInfo;
    var appIDToShow = appInfo.id;
    if (appIDToShow == AppType.Multigames) {
      currentAppIndex = -1;
    } else {
      currentAppID = _allAppsWithShortcuts.keys.firstWhere((id) => id == appIDToShow);

      print("currentAppID : $currentAppID");
      currentApp = _allAppsWithShortcuts[currentAppID];
      currentAppIndex = currentApp["index"];
      print("currentAppIndex: $currentAppIndex");
      var keyApp = _allAppsWithShortcuts.keys.firstWhere((id) => id == appIDToShow);
      _loadedApps[currentAppIndex] = _allAppsWithShortcuts[keyApp]["app"];
    }

    bool multiIframesON = currentAppIndex == -1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FullAppContainerBar(appInfo: appInfo),
        SizedBox(height: 5),
        Stack(
          children: [
            Multigames(),
            Offstage(offstage: multiIframesON, child: Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height - 80, color: Colors.white)),
            Offstage(offstage: multiIframesON, child: IndexedStack(children: _loadedApps, index: currentAppIndex)),
          ],
        )
      ],
    );
  }
}
