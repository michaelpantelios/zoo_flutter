import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoo_flutter/models/nestedapp/nested_app_info.dart';
import 'package:zoo_flutter/providers/app_provider.dart';

class AppBarProvider with ChangeNotifier, DiagnosticableTreeMixin {
  static AppBarProvider instance;

  Map<AppType, List<NestedAppInfo>> _appsMap;

  AppBarProvider() {
    instance = this;
    _appsMap = Map<AppType, List<NestedAppInfo>>();
    AppType.values.forEach((type) {
      _appsMap[type] = [];
    });
  }

  addNestedApp(AppType parentApp, NestedAppInfo nestedAppInfo) {
    print("addNestedApp: ${parentApp} -- ${nestedAppInfo}");
    if (_appsMap[parentApp].firstWhere((item) => item.id == nestedAppInfo.id, orElse: () => null) != null) {
      print("ALREADY EXISTS!!!: ${nestedAppInfo.id}");
      return false;
    }
    _appsMap[parentApp].add(nestedAppInfo);

    notifyListeners();

    return true;
  }

  removeNestedApp(AppType parentApp, NestedAppInfo nestedAppInfo) {
    _appsMap[parentApp].removeWhere((item) => item.id == nestedAppInfo.id);

    notifyListeners();
  }

  List<NestedAppInfo> getNestedApps(AppType rootApp) {
    return _appsMap[rootApp];
  }

  activateApp(AppType parentApp, NestedAppInfo nestedAppInfo) {
    print("activate app: ${parentApp} -- nestedAppInfo: $nestedAppInfo");
    List<NestedAppInfo> lst = _appsMap[parentApp];
    if (nestedAppInfo == null) {
      lst.forEach((item) {
        item.active = false;
      });
    } else {
      lst.forEach((item) {
        item.active = (item.id == nestedAppInfo.id);
      });
    }

    print("_appsMap[parentApp]:");
    print(_appsMap[parentApp]);

    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<AppType, List<NestedAppInfo>>>('appsMap', _appsMap));
  }
}
