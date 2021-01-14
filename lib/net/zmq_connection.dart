import 'dart:async';
import 'dart:math';

import 'package:lazytime/connection.dart';
import 'package:zoo_flutter/utils/env.dart';

class ZMQConnection {

    static const zmqTries = 5;

    StreamController _onCloseController = new StreamController.broadcast();
    StreamController<ZMQMessage> _onMessageController = new StreamController.broadcast();
    Stream get onClose => _onCloseController.stream;
    Stream<ZMQMessage> get onMessage => _onMessageController.stream;

    bool connected = false;
    bool authenticated = false;     // auth data have been sent to the server
    List<String> _hosts = [];
    Connection _con;
    String _sessionKey;
    String id = "${Random().nextInt(999999999)}${Random().nextInt(999999999)}";    // 18 digit random
    Completer _authRes;

    Future<void> connect(String sessionKey) async {
      print("zmq: connecting: channnelId: $id, sessionKey: $sessionKey");
      _sessionKey = sessionKey;

      _con = await _connectMany();
      if(_con == null)
        throw "cannot connect";

      print("zmq: connected (auth: $authenticated)");
      connected = true;
      _setupConnection();

      // if authenticate() was called while we were connecting, call again to resume
      if(_authRes != null)
        authenticate(_sessionKey);
    }

    Future<void> _reconnect() async {
      print("zmq: lost connection, reconnecting");

      _con = await _connectMany();
      if(_con == null) {
        connected = false;
        _onCloseController.add("cannot reconnect");
        return;
      }

      print("zmq: reconnected");
      _setupConnection();
    }

    _setupConnection() {
      _con.onClose.listen((event) => _reconnect());

      _con.registerHandler("chsPushMessages", (Map msgs) {
        print("chsPushMessages $msgs");

        for(var list in msgs.values)
          for(var msg in list)
            _onMessageController.add(ZMQMessage(msg[0], msg[1]));
      });
      _con.registerHandler("chsDestroy", (channelId) {
        connected = false;
        _onCloseController.add("destroyed");
        _con = null;
      });
    }

    Future<Connection> _connectMany() async {
      for(var i = 0; i < zmqTries; i++) {
        var _con = await _connectOnce();
        if(_con != null)
          return _con;

        await Future.delayed(Duration(seconds: pow(2, i)));
      }
      return null;
    }

    Future<Connection> _connectOnce() async {
      var _con = Connection();

      try {
        var url = _nextUrl();
        print("zmq: trying $url");
        await _con.connect(url);
      } catch(e) {
        return null;
      }

      var res = new Completer<Connection>();

      void onConnect(bool success, String userId) {
        _con.unregisterHandler("chsConnectSuccess");
        _con.unregisterHandler("chsConnectError");

        authenticated = (userId != null);

        res.complete(success ? _con : null);
      }

      _con.registerHandler("chsConnectSuccess", (String channelId, String userId) => onConnect(true, userId));
      _con.registerHandler("chsConnectError",   (String channelId) => onConnect(false, null));

      var authData = _sessionKey != null ? { "sessionKey": _sessionKey } : null;
      _con.call("connectChannel", ['Zoo.Idle', id, !connected, authData]);

      return res.future;
    }

    Future<bool> authenticate(String sessionKey) {
      print("zmq: authenticate with sessionKey: $sessionKey");
      _sessionKey = sessionKey;

      if(_authRes == null)
        _authRes = new Completer<bool>();

      if(!connected)
        return _authRes.future;               // if we are not connected, stop now, we will resume after the connection.
      else if(authenticated)
        throw "cannot authenticate twice";

      void onAuth(bool success) {
        _con.unregisterHandler("chsAuthSuccess");
        _con.unregisterHandler("chsAuthError");

        print("zmq: authenticated: $success");
        authenticated = success;
        _authRes.complete(success);
        _authRes = null;
      }

      _con.registerHandler("chsAuthSuccess", (String channelId, String userId) => onAuth(true));
      _con.registerHandler("chsAuthError",   (String channelId) => onAuth(false));

      _con.call("authenticateChannel", [id, { "sessionKey": _sessionKey }]);

      return _authRes.future;
    }

    String _nextUrl() {
      if(_hosts.length == 0)
        _hosts = List.from(Env.zmqHosts);

      var pos = Random().nextInt(_hosts.length);		
      var host = _hosts.removeAt(pos);
      var instance = 1 + Random().nextInt(Env.zmqInstances);		

      return "https://$host/chs/Zoo_$instance/";
    }

}

class ZMQMessage {
  String name;
  dynamic args;

  ZMQMessage(this.name, this.args);
}