@JS('lazytime.net')
library lazytime_net;

// JS classes, DON'T use them directly

import 'package:js/js.dart';

@JS()
class NetConnection {
  external String get uri;
  external Object get client;
  external set client(Object c);
  
  external NetConnection();

  external connect_alt(String uri, List<Object> args); // ignore: non_constant_identifier_names
  external call_alt(String method, Responder responder, List<Object> args); // ignore: non_constant_identifier_names
  external close();
  external addEventListener(String event, Function listener);
}

@JS('Responder')
class Responder {
  external Responder(Function result, Function status);
}


