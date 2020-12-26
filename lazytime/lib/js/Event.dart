@JS('lazytime.events')
library lazytime_events;

// JS classes, DON'T use them directly

import 'package:js/js.dart';

@JS()
class NetStatusEvent {
  static const NET_STATUS = 'netStatus';

  external _EventInfo get info;
}

@JS()
class SyncEvent {
  static const SYNC = 'sync';

  external _EventInfo get info;
}

@JS()
@anonymous
class _EventInfo {
  String code;
}

