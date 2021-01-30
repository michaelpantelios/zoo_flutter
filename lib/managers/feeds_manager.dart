import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:zoo_flutter/main.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/utils/utils.dart';

class Feed {
  final String type;
  final dynamic date;
  int read;
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

  @override
  String toString() {
    return "type: ${type} - date: ${date} - read: ${read} - from: ${from} - data: ${data}";
  }
}

class FeedsManager {
  OverlayEntry _overlayEntry;
  BuildContext _context;
  RPC _rpc;
  final double _width = 325.0;

  List<Feed> _feeds;
  ScrollController _feedsScrollController = ScrollController();
  Function _onClose;

  FeedsManager(BuildContext context, Function onClose) {
    print('FeedsManager constructor');
    _onClose = onClose;
    _context = context;
    _rpc = RPC();
    _feeds = [];
  }

  fetchAlerts() async {
    print('fetchAlerts!');
    _feeds = [];
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

    print(_feeds);
  }

  void show() async {
    await fetchAlerts();
    await _markAllRead();

    _overlayEntry = OverlayEntry(
      opaque: false,
      builder: (context) {
        return Positioned(
          top: GlobalSizes.taskManagerHeight - 5,
          right: 10,
          child: Container(
            width: _width,
            height: Root.AppSize.height - 90,
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
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Scrollbar(
                  isAlwaysShown: true,
                  controller: _feedsScrollController,
                  child: ListView.builder(
                      controller: _feedsScrollController,
                      itemCount: _feeds.length,
                      itemBuilder: (BuildContext context, int index) {
                        Feed feed = _feeds[index];
                        return _feedRenderer(feed);
                      }),
                ),
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(_context).insert(_overlayEntry);
  }

  Widget _feedRenderer(Feed feed) {
    print(feed);
    var prefix = "feeds_";
    var description = "";
    var iconName = "";
    var image;
    var forumId;
    var topicId;
    bool male = true;
    if (feed.from == null) {
      male = UserProvider.instance.userInfo.sex == 1;
      image = UserProvider.instance.userInfo.mainPhoto != null
          ? Image.network(Utils.instance.getUserPhotoUrl(photoId: UserProvider.instance.userInfo.mainPhoto["image_id"].toString()), height: 45, width: 45, fit: BoxFit.fitWidth)
          : Image.asset(male ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 45, width: 45, fit: BoxFit.fitWidth);
    } else {
      male = int.parse(feed.from["sex"].toString()) == 1;
      image = feed.from["mainPhoto"] != null
          ? Image.network(Utils.instance.getUserPhotoUrl(photoId: feed.from["mainPhoto"]["image_id"].toString()), height: 45, width: 45, fit: BoxFit.fitWidth)
          : Image.asset(male ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 45, width: 45, fit: BoxFit.fitWidth);
    }

    switch (feed.type) {
      case "gift_sent_to_me":
        iconName = "feed_gift_icon";
        description = Utils.instance.format(
            AppLocalizations.of(_context).translateWithArgs(
              "${prefix}gift_sent_to_me",
              [AppLocalizations.of(_context).translate(male ? "feeds_male_from" : "feeds_female_from"), ((feed.from["fbName"] != null) ? (feed.from["username"] + " (" + feed.from["fbName"] + ")") : feed.from["username"])],
            ),
            ["<b>|</b>"]);
        break;
      case "friends_birthday":
        iconName = "feed_bday_icon";
        description = Utils.instance.format(
            AppLocalizations.of(_context).translateWithArgs(
              "${prefix}friends_birthday",
              [AppLocalizations.of(_context).translate(male ? "feeds_male_from" : "feeds_female_from"), ((feed.from["fbName"] != null) ? (feed.from["username"] + " (" + feed.from["fbName"] + ")") : feed.from["username"])],
            ),
            ["<b>|</b>"]);
        break;
      case "friend_upload_photo":
        iconName = "feed_photo_icon";
        description = Utils.instance.format(
            AppLocalizations.of(_context).translateWithArgs(
              "${prefix}friend_upload_photo",
              [AppLocalizations.of(_context).translate(male ? "feeds_male_from" : "feeds_female_from"), ((feed.from["fbName"] != null) ? (feed.from["username"] + " (" + feed.from["fbName"] + ")") : feed.from["username"])],
            ),
            ["<b>|</b>"]);
        break;
      case "friend_upload_video":
        iconName = "feed_photo_icon";
        description = Utils.instance.format(
            AppLocalizations.of(_context).translateWithArgs(
              "${prefix}friend_upload_video",
              [AppLocalizations.of(_context).translate(male ? "feeds_male_from" : "feeds_female_from"), ((feed.from["fbName"] != null) ? (feed.from["username"] + " (" + feed.from["fbName"] + ")") : feed.from["username"])],
            ),
            ["<b>|</b>"]);
        break;
      case "level_new_me":
        iconName = "feed_level_icon";
        description = Utils.instance.format(AppLocalizations.of(_context).translateWithArgs("${prefix}level_new_me", [feed.data["level"].toString()]), ["<b>|</b>"]);
        break;
      case "level_new_friend":
        iconName = "feed_level_icon";
        description = Utils.instance.format(
            AppLocalizations.of(_context).translateWithArgs("${prefix}level_new_friend", [AppLocalizations.of(_context).translate(male ? "feeds_male_from" : "feeds_female_from"), ((feed.from["fbName"] != null) ? (feed.from["username"] + " (" + feed.from["fbName"] + ")") : feed.from["username"])]),
            ["<b>|</b>"]);
        break;
      case "new_friend":
        iconName = "feed_friends_icon";
        description = Utils.instance.format(
            AppLocalizations.of(_context).translateWithArgs(
              "${prefix}new_friend",
              [
                AppLocalizations.of(_context).translate(male ? "feeds_male_with" : "feeds_female_with"),
                ((feed.from["fbName"] != null) ? (feed.from["username"] + " (" + feed.from["fbName"] + ")") : feed.from["username"]),
              ],
            ),
            ["<b>|</b>"]);
        break;
      case "forum_reply":
        iconName = "feed_forum_icon";
        forumId = feed.data["forumId"];
        topicId = feed.data["forumId"];
        description = Utils.instance.format(
            AppLocalizations.of(_context).translateWithArgs(
              "${prefix}forum_reply",
              [AppLocalizations.of(_context).translate(male ? "feeds_male_from" : "feeds_female_from"), ((feed.from["fbName"] != null) ? (feed.from["username"] + " (" + feed.from["fbName"] + ")") : feed.from["username"])],
            ),
            ["<b>|</b>"]);
        break;
      case "forum_new_topic":
        iconName = "feed_forum_icon";
        forumId = feed.data["forumId"];
        topicId = feed.data["forumId"];
        description = Utils.instance.format(
            AppLocalizations.of(_context).translateWithArgs(
              "${prefix}forum_new_topic",
              [AppLocalizations.of(_context).translate(male ? "feeds_male_from" : "feeds_female_from"), ((feed.from["fbName"] != null) ? (feed.from["username"] + " (" + feed.from["fbName"] + ")") : feed.from["username"])],
            ),
            ["<b>|</b>"]);
        break;
      default:
        print('Ignore feed: ${feed.type}');
        break;
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _onClose();
            switch (feed.type) {
              case "gift_sent_to_me":
                PopupManager.instance.show(context: _context, popup: PopupType.Profile, callbackAction: (r) {});
                break;
              case "friends_birthday":
                PopupManager.instance.show(context: _context, popup: PopupType.Gifts, headerOptions: feed.from["username"], options: feed.from["username"], callbackAction: (r) {});
                break;
              case "friend_upload_photo":
                PopupManager.instance.show(context: _context, popup: PopupType.Profile, options: feed.from["userId"], callbackAction: (r) {});
                break;
              case "friend_upload_video":
                PopupManager.instance.show(context: _context, popup: PopupType.Profile, options: feed.from["userId"], callbackAction: (r) {});
                break;
              case "level_new_me":
                PopupManager.instance.show(context: _context, popup: PopupType.Profile, callbackAction: (r) {});
                break;
              case "level_new_friend":
                PopupManager.instance.show(context: _context, popup: PopupType.Profile, options: feed.from["userId"], callbackAction: (r) {});
                break;
              case "new_friend":
                PopupManager.instance.show(context: _context, popup: PopupType.Profile, options: feed.from["userId"], callbackAction: (r) {});
                break;
              case "forum_reply":
                AppProvider.instance.activate(AppProvider.instance.getAppInfo(AppType.Forum).id, _context, {"topicId": topicId, "forumId": forumId});
                break;
              case "forum_new_topic":
                AppProvider.instance.activate(AppProvider.instance.getAppInfo(AppType.Forum).id, _context, {"topicId": topicId, "forumId": forumId});
                break;
            }
          },
          child: Container(
            width: _width,
            height: 65,
            color: feed.read == 0 ? Color(0xfff7f7f7) : Color(0xffffffff),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ClipOval(child: image),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: 195,
                    child: HtmlWidget(
                      """<span>$description</span>""",
                      textStyle: TextStyle(
                        color: Color(0xff393e54),
                        fontWeight: feed.read == 0 ? FontWeight.w500 : FontWeight.w200,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Utils.instance.getNiceDateHoursMins(_context, int.parse(feed.date["__datetime__"].toString())),
                        style: TextStyle(
                          color: Color(0xff9598a4),
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Image.asset(
                        "assets/images/notifications/${iconName}.png",
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          height: 2,
          color: Color(0xffe4e6e9),
        )
      ],
    );
  }

  _markAllRead() async {
    var res = await _rpc.callMethod("Alerts.Main.markRead");
    print(res);
    if (res["status"] == "ok") {
      for (var item in _feeds) {
        item.read = 1;
      }
    }
  }

  void hide() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }
}
