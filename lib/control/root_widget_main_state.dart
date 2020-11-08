import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/apps/open_app_model.dart';
import 'package:zoo_flutter/panel/panel.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/containers/full/full_app_container.dart';
import 'package:zoo_flutter/containers/popup/popup_container.dart';
import 'package:zoo_flutter/models/apps/app_info_model.dart';

//this is an InheritedWidget that is recreated each time
// we open/close a window via a click on panel or container buttons
class AppRootWidget extends InheritedWidget {
  AppRootWidget({
    Key key,
    @required Widget child,
    @required this.mainState,
  }) : super(key: key, child: child);

  final MainState mainState;

  @override
  bool updateShouldNotify(AppRootWidget oldRootWidget) {
    return true;
  }
}

//the main widget - container of all
class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);

  @override
  MainState createState() => MainState();

  static MainState of([BuildContext context, bool rebuild = true]) {
    return rebuild
        ? context.dependOnInheritedWidgetOfExactType<AppRootWidget>()
        : context.dependOnInheritedWidgetOfExactType<AppRootWidget>().mainState;
  }
}

class MainState extends State<Main> {
  Panel _panel;
  FullAppContainer _fullAppContainer;
  PopupContainer _popupContainer;

  List<OpenAppModel> openApps = new List<OpenAppModel>();
  OpenAppModel activeApp;

  void openApp(AppInfoModel appInfo) {
    print("openAppsNum: " + openApps.length.toString());
    bool isOpen =
        openApps.where((app) => app.appId == appInfo.appId).isNotEmpty;
    if (!isOpen) {
      print("about to open " + appInfo.appName);
      GlobalKey appKey = GlobalKey();
      OpenAppModel newOpenApp =
          new OpenAppModel(appId: appInfo.appId, key: appKey, active: true);
      activeApp = newOpenApp;
      openApps.add(newOpenApp);
    } else {
      print("already opened " + appInfo.appName);
      OpenAppModel _app = openApps.where((app) => app.appId == appInfo.appId).first;
      _app.active = true;
      activeApp = _app;
    }

    openApps.forEach((oa) {
      oa.active = oa.appId == appInfo.appId;
    });

    print("openAppsNum: " + openApps.length.toString());

    print("active app: " +
        openApps.where((element) => element.active).first.appId);

    printOpenApps();
  }

  printOpenApps() {
    for (int i = 0; i < openApps.length; i++) {
      print("Open App: " +
          openApps[i].appId +
          ", active: " +
          openApps[i].active.toString());
    }
  }

  @override
  void initState() {
    _panel = new Panel();
    _fullAppContainer = new FullAppContainer(appInfo: DataMocker.apps["chat"]);
    _popupContainer = new PopupContainer(appInfo: DataMocker.apps["star"]);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return AppRootWidget(
        mainState: this,
        child: Scaffold(
            body: Stack(
          children: [
            Container(
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
                              child: _fullAppContainer))
                    ])),
            _popupContainer
          ],
        )));
  }
}
