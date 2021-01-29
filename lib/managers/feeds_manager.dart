import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zoo_flutter/main.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

class Feed {
  final String type;
  final dynamic date;
  final int read;
  final dynamic from;
  final dynamic data;

  Feed({this.type, this.date, this.read, this.from, this.data});

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      type: json['type'],
      date: json['date'],
      read: json['read'],
      from: json['from'],
      data: json['data'],
    );
  }
}

class FeedsManager {
  OverlayEntry _overlayEntry;
  BuildContext _context;
  RPC _rpc;

  List<Feed> _feeds;

  FeedsManager(BuildContext context) {
    print('FeedsManager constructor');
    _context = context;
    _rpc = RPC();
    _feeds = [];
  }

  fetchAlerts() async {
    var options = {};
    options["page"] = 1;
    options["recsPerPage"] = 10;
    options["getCount"] = 0;
    var res = await _rpc.callMethod("Alerts.Main.getAlerts", [options]);
    if (res["status"] == "ok") {
      var records = res["data"]["records"];
      for (var item in records) {
        _feeds.add(Feed.fromJson(item));
      }
    }
  }

  void show() {
    _overlayEntry = OverlayEntry(
      opaque: false,
      builder: (context) {
        return Positioned(
          top: GlobalSizes.taskManagerHeight,
          right: 10,
          child: Container(
            width: 300,
            height: Root.AppSize.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              boxShadow: [
                new BoxShadow(
                  color: Color(0x55000000),
                  offset: new Offset(0.2, 2),
                  blurRadius: 3,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(),
            ),
          ),
        );
      },
    );
    Overlay.of(_context).insert(_overlayEntry);
  }

  void hide() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }
}
