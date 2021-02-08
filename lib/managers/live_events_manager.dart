import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/notifications/notification_info.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/notifications_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';

class LiveEventsManager {
  List<NotificationInfo> _liveEvents;
  OverlayEntry _overlayEntry;
  static const TIMEOUT = const Duration(seconds: 4);
  BuildContext _context;
  double dx = 15.0, dy = 15.0, dxStart = 15.0, dyStart = -140.0;
  int animationDuration = 500;

  LiveEventsManager(BuildContext context) {
    print('LiveEventsManager constructor');
    _context = context;
    _liveEvents = [];
    NotificationsProvider.instance.addListener(_onNotification);
  }

  void _onNotification() {
    _liveEvents.add(NotificationsProvider.instance.notifications.last);

    _popAndShowOldest();
  }

  _popAndShowOldest() {
    if (_liveEvents.length > 0) {
      NotificationInfo notificationInfo = _liveEvents.removeAt(0);
      String title = "";
      String description = "";
      Image image;
      var user;
      Function handler = () {};
      print('notificationInfo.name: ${notificationInfo.name}');
      switch (notificationInfo.name) {
        case NotificationType.ON_COINS_CHANGED:
          title = AppLocalizations.of(_context).translate("live_events_coinschanged");
          if (int.parse(notificationInfo.args["diff"].toString()) > 0) {
            description = Utils.instance.format(AppLocalizations.of(_context).translateWithArgs("live_events_increased", [notificationInfo.args["newCoins"]]), ["<b>|</b>"]);
          } else {
            description = Utils.instance.format(AppLocalizations.of(_context).translateWithArgs("live_events_decreased", [notificationInfo.args["newCoins"]]), ["<b>|</b>"]);
          }

          image = Image.asset("assets/images/live_events/coins_icon.png", height: 45, width: 45, fit: BoxFit.fitWidth);

          handler = () {
            PopupManager.instance.show(context: _context, popup: PopupType.Coins, callbackAction: (r) {});
          };
          break;
        case NotificationType.ON_NEW_MAIL:
          user = notificationInfo.args["from"];

          title = AppLocalizations.of(_context).translate("live_events_newmail");
          description = Utils.instance.format(AppLocalizations.of(_context).translateWithArgs("live_events_newmailbody", [user["username"]]), ["<b>|</b>"]);

          image = user["mainPhoto"] != null
              ? Image.network(Utils.instance.getUserPhotoUrl(photoId: user["mainPhoto"]["image_id"].toString()), height: 45, width: 45, fit: BoxFit.fitWidth)
              : Image.asset(user["sex"] == "1" ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 45, width: 45, fit: BoxFit.fitWidth);

          handler = () {
            PopupManager.instance.show(context: _context, popup: PopupType.Mail, callbackAction: (r) {});
          };
          break;
        case NotificationType.ON_NEW_GIFT:
          user = notificationInfo.args["fromUser"];

          title = AppLocalizations.of(_context).translate("live_events_newgift");
          description = Utils.instance.format(AppLocalizations.of(_context).translateWithArgs("live_events_giftFromUser", [user["username"]]), ["<b>|</b>"]);

          image = user["mainPhoto"] != null
              ? Image.network(Utils.instance.getUserPhotoUrl(photoId: user["mainPhoto"]["image_id"].toString()), height: 45, width: 45, fit: BoxFit.fitWidth)
              : Image.asset(user["sex"] == "1" ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 45, width: 45, fit: BoxFit.fitWidth);

          handler = () {
            PopupManager.instance.show(context: _context, popup: PopupType.Profile, callbackAction: (r) {});
          };
          break;
        case NotificationType.ON_SUB_RENEWAL:
          var renewDays = notificationInfo.args["days"].toString();
          title = AppLocalizations.of(_context).translate("live_events_subrenewaltitle");
          description = Utils.instance.format(AppLocalizations.of(_context).translateWithArgs("live_events_subrenewalbody", [renewDays]), ["<b>|</b>"]);

          image = Image.asset("assets/images/live_events/zoo_icon.png", height: 45, width: 45, fit: BoxFit.fitWidth);
          break;
        case NotificationType.ON_SUB_ENDED:
          title = AppLocalizations.of(_context).translate("live_events_subendedtitle");
          description = AppLocalizations.of(_context).translate("live_events_subendedbody");

          image = Image.asset("assets/images/live_events/zoo_icon.png", height: 45, width: 45, fit: BoxFit.fitWidth);
          break;
        case NotificationType.ON_MESSENGER_USER_ONLINE:
          user = notificationInfo.args["user"];
          title = AppLocalizations.of(_context).translate("live_events_friendonlinetitle");
          description = Utils.instance.format(AppLocalizations.of(_context).translateWithArgs("live_events_friendonlinebody", [user["username"]]), ["<b>|</b>"]);
          image = user["mainPhoto"] != null
              ? Image.network(Utils.instance.getUserPhotoUrl(photoId: user["mainPhoto"]["image_id"].toString()), height: 45, width: 45, fit: BoxFit.fitWidth)
              : Image.asset(user["sex"] == "1" ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 45, width: 45, fit: BoxFit.fitWidth);

          handler = () {
            AppProvider.instance.activate(AppType.Messenger, _context, {"user_online": user});
          };
          break;
        case NotificationType.ON_MESSENGER_USER_OFFLINE:
          break;
        case NotificationType.ON_MESSENGER_CHAT_MESSAGE:
          if (AppProvider.instance.currentAppInfo.id == AppType.Messenger) {
            print('Ignore ON_MESSENGER_CHAT_MESSAGE because the user has open the messenger app!');
          } else {
            user = notificationInfo.args["message"]["from"];
            title = AppLocalizations.of(_context).translate("live_events_chatmsgtitle");
            description = Utils.instance.format(AppLocalizations.of(_context).translateWithArgs("live_events_chatmsgbody", [user["username"]]), ["<b>|</b>"]);
            image = user["mainPhoto"] != null
                ? Image.network(Utils.instance.getUserPhotoUrl(photoId: user["mainPhoto"]["image_id"].toString()), height: 45, width: 45, fit: BoxFit.fitWidth)
                : Image.asset(user["sex"] == "1" ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 45, width: 45, fit: BoxFit.fitWidth);
          }

          handler = () {
            AppProvider.instance.activate(AppType.Messenger, _context, {"user": user});
          };
          break;
        case NotificationType.ON_MESSENGER_FRIEND_REQUEST:
          user = notificationInfo.args["user"];
          title = AppLocalizations.of(_context).translate("live_events_friendreqtitle");
          description = Utils.instance.format(AppLocalizations.of(_context).translateWithArgs("live_events_friendreqbody", [user["username"]]), ["<b>|</b>"]);
          image = user["mainPhoto"] != null
              ? Image.network(Utils.instance.getUserPhotoUrl(photoId: user["mainPhoto"]["image_id"].toString()), height: 45, width: 45, fit: BoxFit.fitWidth)
              : Image.asset(user["sex"] == "1" ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 45, width: 45, fit: BoxFit.fitWidth);

          handler = () {
            PopupManager.instance.show(context: _context, popup: PopupType.Friends, callbackAction: (r) {});
          };
          break;
        default:
          print('Ignore the following event: ${notificationInfo.name}');

          break;
      }

      if (title.isNotEmpty && description.isNotEmpty) _show(title, description, image, handler);
    }
  }

  void _show(String title, String description, Image image, Function handler) {
    if (_overlayEntry != null) {
      print('ALREADY ACTIVE LIVE EVENT!');
      Future.delayed(Duration(seconds: 2), () {
        _show(title, description, image, handler);
      });
      return;
    }
    _overlayEntry = OverlayEntry(
        opaque: false,
        builder: (context) {
          return TweenAnimationBuilder(
              duration: Duration(milliseconds: animationDuration),
              tween: Tween<Offset>(begin: Offset(dxStart, dyStart), end: Offset(dx, dy)),
              builder: (context, offset, widget) {
                return Positioned(
                  bottom: offset.dy,
                  left: offset.dx,
                  child: Container(
                    width: 300,
                    height: 115,
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
                        padding: const EdgeInsets.only(left: 15, top: 10, right: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: Color(0xff64abff),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _closeIt();
                                  },
                                  child: Image.asset(
                                    "assets/images/live_events/close_icon.png",
                                    width: 16,
                                    height: 16,
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ClipOval(child: image),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: GestureDetector(
                                          onTap: handler,
                                          child: Container(
                                            width: 200,
                                            child: HtmlWidget(
                                              """<span>$description</span>""",
                                              textStyle: TextStyle(
                                                color: Color(0xff393e54),
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
    Overlay.of(_context).insert(_overlayEntry);
    Timer(TIMEOUT, _closeIt);
  }

  void _closeIt() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;

      _popAndShowOldest();
    }
  }
}
