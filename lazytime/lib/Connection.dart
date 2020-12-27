import 'dart:async';

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'js/Event.dart';
import 'js/NetConnection.dart';

class Connection {
  NetConnection _con;
  NetConnection get netCon => _con;

  Completer _connectRes;

  StreamController _onCloseController = new StreamController.broadcast();
  Stream get onClose => _onCloseController.stream;

  Connection() {
    _con = NetConnection();
    _con.client = newObject();
    _con.addEventListener(NetStatusEvent.NET_STATUS, allowInterop(_onNetStatus));
  }

  Future<void> connect(String uri, [List<Object> args]) async {
    if (_connectRes != null) throw "cannot connect twice";

    _con.connect_alt(uri, args);

    _connectRes = new Completer();
    return _connectRes.future;
  }

  Future<Object> call(String method, [List<Object> args]) async {
    var completer = Completer();
    var resp = new Responder(allowInterop((r) {
      completer.complete(r);
    }), allowInterop((e) {
      completer.completeError(e);
    }));

    _con.call_alt(method, resp, args);

    return completer.future;
  }

  close() {
    _con.close();
  }

  registerHandler(String name, Function handler) {
    var client = getProperty(_con, "client");
    setProperty(client, name, allowInterop(handler));
  }

  unregisterHandler(String name) {
    var client = getProperty(_con, "client");
    setProperty(client, name, null);
  }

  _onNetStatus(NetStatusEvent e) {
    if (e.info.code == 'NetConnection.Connect.Success') {
      // success
      if (_connectRes == null)
        throw "success without connect()";
      else
        _connectRes.complete();
    } else {
      // failure/close
      if (_connectRes.isCompleted)
        _onCloseController.add(e.info.code);
      else
        _connectRes.completeError(e.info.code);
    }
  }
}
