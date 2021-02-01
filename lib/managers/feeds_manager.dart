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
  Function _onClose;
  RPC _rpc;
  final double _width = 325.0;

  List<Feed> _feeds;
  ScrollController _feedsScrollController = ScrollController();

  List<String> allowedFeeds = [
    "gift_sent_to_me",
    "friends_birthday",
    "friend_upload_photo",
    "friend_upload_video",
    "level_new_me",
    "level_new_friend",
    "new_friend",
    "forum_reply",
    "forum_new_topic",
  ];

  FeedsManager(BuildContext context, Function onClose) {
    print('FeedsManager constructor');
    _context = context;
    _onClose = onClose;
    _rpc = RPC();
    _feeds = [];
  }

  fetchAlerts() async {
    print('fetchAlerts!');
    var options = {};
    options["page"] = 1;
    options["recsPerPage"] = 100;
    options["getCount"] = 0;
    var res = await _rpc.callMethod("Alerts.Main.getAlerts", [options]);
    _feeds = [];
    if (res["status"] == "ok") {
      var records = res["data"]["records"];
      for (var item in records) {
        if (allowedFeeds.contains(item["type"])) _feeds.add(Feed.fromJson(item));
      }
    }

    print(_feeds);
    var unreadFeeds = _feeds.where((element) => element.read == 0).length;

    print('unreadFeeds: ${unreadFeeds}');
    return unreadFeeds;
  }

  void show() async {
    await fetchAlerts();
    _rpc.callMethod("Alerts.Main.markRead");

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
                        return _feedRenderer(index);
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

  Widget _feedRenderer(int index) {
    Feed feed = _feeds[index];
    Feed feedBefore;
    bool sameDayAsLastOne = false;
    var dateInSecs = int.parse(feed.date["__datetime__"].toString());
    DateTime feedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(feed.date["__datetime__"].toString()) * 1000);
    if (index > 0) {
      feedBefore = _feeds[index - 1];
      DateTime feedBeforeDate = DateTime.fromMillisecondsSinceEpoch(int.parse(feedBefore.date["__datetime__"].toString()) * 1000);

      sameDayAsLastOne = (feedBeforeDate.weekday == feedDate.weekday && feedBeforeDate.month == feedDate.month && feedBeforeDate.year == feedDate.year);
    }
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
        return Container();
        break;
    }

    DateTime today = DateTime.now();
    bool isToday = today.day == feedDate.day && today.month == feedDate.month && today.year == feedDate.year;
    bool isYesterday = today.day - 1 == feedDate.day && today.month == feedDate.month && today.year == feedDate.year;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            hide();
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
          child: Column(
            children: [
              !sameDayAsLastOne
                  ? Container(
                      width: _width,
                      height: 34,
                      color: Color(0xffe4e6e9),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 9),
                        child: Text(
                          isToday
                              ? AppLocalizations.of(_context).translate("app_forum_today")
                              : isYesterday
                                  ? AppLocalizations.of(_context).translate("app_forum_yesterday")
                                  : Utils.instance.getNiceDateDayOfMonth(_context, dateInSecs),
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            color: Color(0xff9598a4),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Container(
                width: _width,
                height: 65,
                color: Color(0xffffffff),
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
                            fontWeight: FontWeight.w200,
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
                            Utils.instance.getNiceDateHoursMins(_context, dateInSecs),
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
            ],
          ),
        ),
        Container(
          height: 2,
          color: Color(0xffe4e6e9),
        )
      ],
    );
  }

  void hide() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;

      _onClose();
    }
  }
}
