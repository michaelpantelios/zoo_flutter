import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/browsergames/browsergames.dart';
import 'package:zoo_flutter/apps/chat/chat.dart';
import 'package:zoo_flutter/apps/home/home.dart';
import 'package:zoo_flutter/apps/multigames/multigames.dart';
import 'package:zoo_flutter/containers/full/full_app_container_bar.dart';
import 'package:zoo_flutter/managers/feeds_manager.dart';
import 'package:zoo_flutter/managers/live_events_manager.dart';
import 'package:zoo_flutter/panel/panel.dart';
import 'package:zoo_flutter/providers/app_bar_provider.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/notifications_provider.dart';
import 'package:zoo_flutter/taskmanager/task_manager.dart';
import 'package:zoo_flutter/theme/theme.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

import 'apps/forum/forum.dart';
import 'apps/messenger/messenger.dart';
import 'apps/search/search.dart';
import 'apps/singleplayergames/singleplayer_games.dart';
import 'js/zoo_lib.dart';
import 'providers/user_provider.dart';

void main() {
  Zoo.appLoaded();
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
  static Size AppSize;
  static LiveEventsManager liveEventsManager;
  static FeedsManager feedsManager;

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  GlobalKey<TaskManagerState> _taskManagerKey = GlobalKey();

  @override
  void initState() {
    Root.liveEventsManager = LiveEventsManager(context);
    Root.feedsManager = FeedsManager(context, () => _taskManagerKey.currentState.resetNotificationButton());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Root.AppSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Theme.of(context).canvasColor,
        width: Root.AppSize.width,
        height: Root.AppSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TaskManager(_taskManagerKey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Panel(),
                //to full app container
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(GlobalSizes.fullAppMainPadding),
                    // child: Container(
                    child: _barAndFullApp(context),
                    // ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _barAndFullApp(BuildContext context) {
    var appInfo = context.watch<AppProvider>().currentAppInfo;
    AppType appTypeToShow = appInfo.id;
    bool removeBarHeight = appTypeToShow != AppType.Home;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FullAppContainerBar(appInfo: appInfo),
        Container(
          width: Root.AppSize.width,
          height: Root.AppSize.height - GlobalSizes.taskManagerHeight - (removeBarHeight ? GlobalSizes.appBarHeight : 0) - 2 * GlobalSizes.fullAppMainPadding,
          color: Colors.white,
          child: _getAppWidget(appTypeToShow),
        ),
      ],
    );
  }

  Widget _getAppWidget(AppType appTypeToShow, [BuildContext context]) {
    Widget widget;
    switch (appTypeToShow) {
      case AppType.Home:
        widget = Home();
        break;
      case AppType.Multigames:
        widget = Multigames();
        break;
      case AppType.BrowserGames:
        widget = BrowserGames();
        break;
      case AppType.SinglePlayerGames:
        widget = SinglePlayerGames();
        break;
      case AppType.Chat:
        widget = Chat();
        break;
      case AppType.Forum:
        widget = Forum();
        break;
      case AppType.Messenger:
        widget = Messenger();
        break;
      case AppType.Search:
        widget = Search();
        break;
      default:
        throw new Exception("Unknown app: $appTypeToShow");
        break;
    }

    return widget;
  }
}
