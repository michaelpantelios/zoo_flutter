import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/multigames/multigames.dart';
import 'package:zoo_flutter/containers/full/full_app_container_bar.dart';
import 'package:zoo_flutter/panel/panel.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/notifications_provider.dart';
import 'package:zoo_flutter/taskmanager/task_manager.dart';
import 'package:zoo_flutter/theme/theme.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

import 'providers/user_provider.dart';

void main() {
  runApp(MyApp());
  setUrlStrategy(null); // don't mess with the url
  var useSkia = const bool.fromEnvironment('FLUTTER_WEB_USE_SKIA', defaultValue: false);
  print("useSkia?? $useSkia");
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
        title: 'Zoo.gr - Το ελληνικό web meeting point',
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

    // Future.delayed(Duration(milliseconds: 2000), () {
    //   PopupManager.instance.show(context: context, popup: PopupType.Coins, callbackAction: (r) {});
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).canvasColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TaskManager(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Panel(),
                //to full app container
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    // child: Container(
                    child: _barAndFullApp(context),
                    // ),
                  ),
                )
              ],
            ),
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

      // print("currentAppID : $currentAppID");
      currentApp = _allAppsWithShortcuts[currentAppID];
      currentAppIndex = currentApp["index"];
      // print("currentAppIndex: $currentAppIndex");
      var keyApp = _allAppsWithShortcuts.keys.firstWhere((id) => id == appIDToShow);
      if (appIDToShow == AppType.Chat && AppProvider.instance.chatGlobalKey.currentState != null) {
        AppProvider.instance.chatGlobalKey.currentState.refresh();
      }
      _loadedApps[currentAppIndex] = PointerInterceptor(child: _allAppsWithShortcuts[keyApp]["app"]);
    }

    bool multiIframesON = currentAppIndex == -1;
    bool removeBarHeight = appIDToShow != AppType.Home;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PointerInterceptor(child: FullAppContainerBar(appInfo: appInfo)),
        Stack(
          children: [
            Multigames(),
            Offstage(
              offstage: multiIframesON,
              child: PointerInterceptor(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
                  color: Colors.white,
                ),
              ),
            ),
            Offstage(
              offstage: multiIframesON,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - GlobalSizes.taskManagerHeight - (removeBarHeight ? GlobalSizes.appBarHeight : 0) - 2 * GlobalSizes.fullAppMainPadding,
                child: IndexedStack(
                  children: _loadedApps,
                  index: currentAppIndex,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
