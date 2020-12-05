import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/containers/full/full_app_container_bar.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/panel/panel.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/theme/theme.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

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
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => AppProvider(),
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
  @override
  void initState() {
    _allAppsWithShortcuts = Map<AppType, dynamic>();
    var index = 0;
    AppType.values.forEach((popup) {
      var popupInfo = AppProvider.instance.getAppInfo(popup);
      if (popupInfo.hasPanelShortcut) {
        _allAppsWithShortcuts[popupInfo.id] = {"app": AppProvider.instance.getAppWidget(popup, context), "index": index};
        index++;
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () async {
      PopupManager.instance.show(
          context: context,
          popup: PopupType.Login,
          callbackAction: (retValue) {
            print("retValue: $retValue");
          });
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
    var currentAppID = _allAppsWithShortcuts.keys.firstWhere((id) => id == context.watch<AppProvider>().currentAppInfo.id);
    print("currentAppID : $currentAppID");
    var currentApp = _allAppsWithShortcuts[currentAppID];
    print("currentApp: $currentApp");
    var currentAppIndex = currentApp["index"];
    print("currentAppIndex: $currentAppIndex");
    List<Widget> shortcutApps = [];
    _allAppsWithShortcuts.values.forEach((item) {
      shortcutApps.add(item["app"]);
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FullAppContainerBar(
          title: context.watch<AppProvider>().currentAppInfo.appName,
          iconData: context.watch<AppProvider>().currentAppInfo.iconPath,
        ),
        SizedBox(height: 5),
        IndexedStack(
          children: shortcutApps,
          index: currentAppIndex,
        )
      ],
    );
  }
}
