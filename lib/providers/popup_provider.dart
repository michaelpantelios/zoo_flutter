import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';

class PopupProvider with ChangeNotifier, DiagnosticableTreeMixin {
  static PopupProvider instance = null;
  Map<PopupType, bool> _busyPopups;

  PopupProvider() {
    print("popup provider");
    instance = this;
    _busyPopups = Map();
  }

  makeBusy(PopupType popup, bool busy) {
    _busyPopups[popup] = busy;
    notifyListeners();
  }

  isBusy(PopupType popup) {
    return _busyPopups[popup];
  }

  Map<PopupType, bool> get busyPopups => _busyPopups;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
