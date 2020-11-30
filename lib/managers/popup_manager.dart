import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zoo_flutter/apps/coins/coins.dart';
import 'package:zoo_flutter/apps/login/login.dart';
import 'package:zoo_flutter/apps/messenger/messenger_chat.dart';
import 'package:zoo_flutter/apps/photos/photo_camera_upload.dart';
import 'package:zoo_flutter/apps/photos/photo_file_upload.dart';
import 'package:zoo_flutter/apps/photos/photos.dart';
import 'package:zoo_flutter/apps/settings/settings.dart';
import 'package:zoo_flutter/apps/signup/signup.dart';
import 'package:zoo_flutter/apps/star/star.dart';
import 'package:zoo_flutter/apps/videos/videos.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';

enum PopupType {
  Login,
  Signup,
  Profile,
  Star,
  Coins,
  Settings,
  MessengerChat,
  Photos,
  PhotoFileUpload,
  PhotoCameraUpload,
  Videos,
}

class PopupInfo {
  final PopupType id;
  final String appName;
  final IconData iconPath;
  final Size size;

  PopupInfo({
    @required this.id,
    @required this.appName,
    @required this.iconPath,
    this.size,
  });

  @override
  String toString() {
    return "id: ${id}, appName: ${appName}, size: ${size}";
  }
}

class PopupManager {
  PopupManager._privateConstructor();

  static final PopupManager instance = PopupManager._privateConstructor();

  Map<PopupType, Widget> _cachedPopupsWidgets;

  Future<dynamic> show({@required context, @required PopupType popup, id, content, closeFunction, closeIcon, overlayColor = Colors.transparent, onWillPopActive = false, isOverlayTapDismiss = false}) async {
    var popupInfo = getPopUpInfo(popup);
    print(popupInfo);
    return await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        final Widget _child = ConstrainedBox(
          constraints: BoxConstraints.expand(width: double.infinity, height: double.infinity),
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: SimpleDialog(
                key: Key(id),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
                elevation: 10,
                contentPadding: EdgeInsets.zero,
                children: [
                  PopupContainerBar(
                    title: popupInfo.appName,
                    iconData: popupInfo.iconPath,
                    onCloseBtnHandler: () => _closePopup(popup, context, null),
                  ),
                  SizedBox(
                    width: popupInfo.size.width,
                    height: popupInfo.size.height,
                    child: _getPopUpWidget(popup, context),
                  )
                ],
              ),
            ),
          ),
        );
        return onWillPopActive ? WillPopScope(onWillPop: () async => false, child: _child) : _child;
      },
      barrierDismissible: isOverlayTapDismiss,
      barrierColor: overlayColor,
      useRootNavigator: true,
    );
  }

  PopupInfo getPopUpInfo(PopupType popup) {
    PopupInfo info;
    switch (popup) {
      case PopupType.Login:
        info = PopupInfo(
          id: popup,
          appName: "app_name_login",
          iconPath: Icons.login,
          size: new Size(600, 410),
        );
        break;
      case PopupType.Signup:
        info = PopupInfo(
          id: popup,
          appName: "app_name_signup",
          iconPath: Icons.edit,
          size: new Size(600, 460),
        );
        break;
      case PopupType.Profile:
        info = PopupInfo(
          id: popup,
          appName: "app_name_profile",
          iconPath: Icons.account_box,
          size: new Size(600, 460),
        );
        break;
      case PopupType.Star:
        info = PopupInfo(
          id: popup,
          appName: "app_name_star",
          iconPath: Icons.star,
          size: new Size(700, 650),
        );
        break;
      case PopupType.Coins:
        info = PopupInfo(
          id: popup,
          appName: "app_name_coins",
          iconPath: Icons.copyright,
          size: new Size(600, 650),
        );
        break;
      case PopupType.Settings:
        info = PopupInfo(
          id: popup,
          appName: "app_name_settings",
          iconPath: Icons.settings,
          size: new Size(650, 400),
        );
        break;
      case PopupType.MessengerChat:
        info = PopupInfo(
          id: popup,
          appName: "app_name_messengerChat",
          iconPath: Icons.chat_bubble,
          size: new Size(600, 460),
        );
        break;
      case PopupType.Photos:
        info = PopupInfo(
          id: popup,
          appName: "app_name_photos",
          iconPath: Icons.photo_camera,
          size: new Size(600, 400),
        );
        break;
      case PopupType.PhotoFileUpload:
        info = PopupInfo(
          id: popup,
          appName: "app_name_photo_file_upload",
          iconPath: Icons.add_photo_alternate_outlined,
          size: new Size(500, 205),
        );
        break;
      case PopupType.PhotoCameraUpload:
        info = PopupInfo(
          id: popup,
          appName: "app_name_photo_camera_upload",
          iconPath: Icons.linked_camera,
          size: new Size(400, 600),
        );
        break;
      case PopupType.Videos:
        info = PopupInfo(
          id: popup,
          appName: "app_name_videos",
          iconPath: Icons.video_collection,
          size: new Size(650, 500),
        );
        break;
      default:
        throw new Exception("Uknwown popup: ${popup}");
        break;
    }

    return info;
  }

  Widget _getPopUpWidget(PopupType popup, [BuildContext context]) {
    if (_cachedPopupsWidgets == null) _cachedPopupsWidgets = Map<PopupType, Widget>();
    if (_cachedPopupsWidgets.containsKey(popup)) return _cachedPopupsWidgets[popup];

    Widget widget;
    var info = getPopUpInfo(popup);
    switch (popup) {
      case PopupType.Login:
        widget = Login();
        break;
      case PopupType.Signup:
        widget = Signup(onCB: (retValue) => _closePopup(popup, context, retValue));
        break;
      case PopupType.Profile:
        widget = Container();
        break;
      case PopupType.Star:
        widget = Star(size: info.size);
        break;
      case PopupType.Coins:
        widget = Coins(size: info.size);
        break;
      case PopupType.Settings:
        widget = Settings(size: info.size);
        break;
      case PopupType.MessengerChat:
        widget = MessengerChat();
        break;
      case PopupType.Photos:
        widget = Photos(info.size);
        break;
      case PopupType.PhotoFileUpload:
        widget = PhotoFileUpload(info.size);
        break;
      case PopupType.PhotoCameraUpload:
        widget = PhotoCameraUpload(info.size);
        break;
      case PopupType.Videos:
        widget = Videos(info.size);
        break;
      default:
        throw new Exception("Uknwown popup: ${popup}");
        break;
    }

    _cachedPopupsWidgets[popup] = widget;

    return widget;
  }

  _closePopup(PopupType popup, BuildContext context, dynamic retValue) {
    print("close!!!");
    Navigator.of(context, rootNavigator: true).pop(retValue);
  }
}