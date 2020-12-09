import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoo_flutter/models/notifications/notification_info.dart';
import 'package:zoo_flutter/providers/app_provider.dart';

class NotificationsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  static NotificationsProvider instance;

  List<NotificationInfo> _notifications;

  NotificationsProvider() {
    print("Notifications provider!");
    instance = this;
    _notifications = [];
  }

  addNotification(NotificationInfo notification) {
    if (AppProvider.instance.currentAppInfo.id == notification.type) {
      print("Dont add this notification, user has already activated the current app: ${notification.type}");
      return;
    }
    notification.id = _notifications.length;
    _notifications.add(notification);

    notifyListeners();
  }

  removeNotificationsOfType(AppType type) {
    _notifications.removeWhere((notification) => notification.type == type);

    notifyListeners();
  }

  List<NotificationInfo> get notifications => _notifications;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<List<NotificationInfo>>('notifications', _notifications));
  }
}
