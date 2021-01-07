import 'dart:async';
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:lazytime/connection.dart';

import 'js/aux.dart';
import 'js/shared_object.dart' as js;
import 'js/net_connection.dart' as js;
import 'js/event.dart';

class SharedObject {
  js.SharedObject _so;
  js.NetConnection _con;
  Completer _connectRes;

  StreamController _onSyncController = new StreamController.broadcast();
  Stream get onSync => _onSyncController.stream;

  SharedObject(String name, Connection con) {
    _con = con.netCon;
    _so = js.SharedObject.getRemote(name, _con.uri);
    _so.client = newObject();
    _so.addEventListener(SyncEvent.SYNC, allowInterop(_onSync));
  }

  Future<void> connect() async {
    if (_connectRes != null) throw "cannot connect twice";

    _so.connect(_con);

    _connectRes = new Completer();
    return _connectRes.future;
  }

  close() {
    _so.close();
  }

  registerHandler(String name, Function handler) {
    var client = getProperty(_so, "client");
    setProperty(client, name, Aux.wrapHandler(name, handler));
  }

  unregisterHandler(String name) {
    var client = getProperty(_so, "client");
    setProperty(client, name, null);
  }

  _onSync(SyncEvent e) {
    if (!_connectRes.isCompleted)
      _connectRes.complete();

    _onSyncController.add(Aux.jsToDart(_so.data));
  }
}
