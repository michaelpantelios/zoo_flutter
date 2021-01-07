@JS('lazytime.net')
library lazytime_net;

// JS classes, DON'T use them directly

import 'package:js/js.dart';
import 'net_connection.dart';

@JS()
class SharedObject {
  external Object get data;
  external Object get client;
  external set client(Object c);
  
  external static getRemote(String name, String uri);

  external connect(NetConnection connection);
  external close();
  external addEventListener(String event, Function listener);
}


