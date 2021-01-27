import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoo_flutter/models/notifications/notification_info.dart';

class NotificationsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  static NotificationsProvider instance;

  List<NotificationInfo> _notifications;

  NotificationsProvider() {
    instance = this;
    _notifications = [];
  }

  addNotification(NotificationInfo notification) {
    _notifications.removeWhere((item) => item.type == notification.type);
    notification.id = _notifications.length;
    _notifications.add(notification);

    notifyListeners();
  }

  removeNotification(NotificationInfo notification) {
    _notifications.removeWhere((item) => item.type == notification.type);
    notifyListeners();
  }

  List<NotificationInfo> get notifications => _notifications;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<List<NotificationInfo>>('notifications', _notifications));
  }
}
