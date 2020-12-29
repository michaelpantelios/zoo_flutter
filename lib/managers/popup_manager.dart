import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/apps/chat/chat_master_ban.dart';
import 'package:zoo_flutter/apps/coins/coins.dart';
import 'package:zoo_flutter/apps/gifts/gifts.dart';
import 'package:zoo_flutter/apps/login/login.dart';
import 'package:zoo_flutter/apps/messenger/messenger_chat.dart';
import 'package:zoo_flutter/apps/photos/photo_camera_upload.dart';
import 'package:zoo_flutter/apps/photos/photo_file_upload.dart';
import 'package:zoo_flutter/apps/photos/photo_viewer.dart';
import 'package:zoo_flutter/apps/photos/photos.dart';
import 'package:zoo_flutter/apps/profile/profile.dart';
import 'package:zoo_flutter/apps/settings/settings.dart';
import 'package:zoo_flutter/apps/signup/signup.dart';
import 'package:zoo_flutter/apps/sms/SMSActivation.dart';
import 'package:zoo_flutter/apps/star/star.dart';
import 'package:zoo_flutter/apps/videos/videos.dart';
import 'package:zoo_flutter/apps/protector/protector.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

enum PopupType { Login, Signup, Profile, ProfileEdit, Star, Coins, Settings, MessengerChat, Photos, PhotoViewer, PhotoFileUpload, PhotoCameraUpload, Videos, SMSActivation, ChatMasterBan, Gifts, Protector }

class PopupInfo {
  final PopupType id;
  final String appName;
  final IconData iconPath;
  final Size size;
  final bool requiresLogin;

  PopupInfo({
    @required this.id,
    @required this.appName,
    @required this.iconPath,
    @required this.requiresLogin,
    this.size,
  });

  @override
  String toString() {
    return "id: $id, appName: $appName, size: $size";
  }
}

typedef OnCallbackAction = void Function(dynamic retValue);

class GeneralDialog extends StatefulWidget {
  final PopupInfo popupInfo;
  final OnCallbackAction onCallback;
  final BuildContext context;
  final dynamic options;
  GeneralDialog(this.popupInfo, this.onCallback, this.context, this.options);
  @override
  _GeneralDialogState createState() => _GeneralDialogState();
}

class _GeneralDialogState extends State<GeneralDialog> {
  Widget _dialogWidget;
  bool _busy = false;
  double _finalHeight;

  _onBusy(value) {
    print("_GeneralDialogState - _onBusy - $value");
    setState(() {
      _busy = value;
    });
  }

  @override
  void initState() {
    _dialogWidget = PopupManager.instance.getPopUpWidget(widget.popupInfo.id, widget.onCallback, _onBusy, widget.context, widget.options);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _finalHeight = (widget.popupInfo.size.height > MediaQuery.of(context).size.height - 100) ? MediaQuery.of(context).size.height - 100 : widget.popupInfo.size.height;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
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
          title: widget.popupInfo.appName,
          iconData: widget.popupInfo.iconPath,
          onClose: () => widget.onCallback(null),
        ),
        SizedBox(
          width: widget.popupInfo.size.width,
          height: _finalHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _dialogWidget,
              _busy
                  ? Container(
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
                    )
                  : Container(),
              _busy
                  ? SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        backgroundColor: Colors.white,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}

class PopupManager {
  PopupManager._privateConstructor();

  static final PopupManager instance = PopupManager._privateConstructor();
  Map<PopupType, PopupInfo> _popups = Map<PopupType, PopupInfo>();

  Future<dynamic> show({@required context, @required PopupType popup, @required OnCallbackAction callbackAction, dynamic options, content, overlayColor = Colors.transparent}) async {
    var popupInfo = getPopUpInfo(popup);
    print(popupInfo.id);
    if (!UserProvider.instance.logged && popupInfo.requiresLogin) {
      popupInfo = getPopUpInfo(PopupType.Login);
    }

    if ((AppProvider.instance.currentAppInfo.id == AppType.Multigames || AppProvider.instance.currentAppInfo.id == AppType.SinglePlayerGames) && !AppProvider.instance.popupOverIFrameExists) {
      AppProvider.instance.popupOverIFrameExists = true;
    }

    return await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return ConstrainedBox(
          constraints: BoxConstraints.expand(width: double.infinity, height: double.infinity),
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: GeneralDialog(popupInfo, (retValue) => _closePopup(callbackAction, popup, buildContext, retValue), buildContext, options),
            ),
          ),
        );
      },
      barrierDismissible: false,
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
          requiresLogin: false,
        );
        break;
      case PopupType.Signup:
        info = PopupInfo(
          id: popup,
          appName: "app_name_signup",
          iconPath: Icons.edit,
          size: new Size(600, 460),
          requiresLogin: false,
        );
        break;
      case PopupType.Profile:
        info = PopupInfo(
          id: popup,
          appName: "app_name_profile",
          iconPath: Icons.account_box,
          size: new Size(700, 800),
          requiresLogin: true,
        );
        break;
      case PopupType.Star:
        info = PopupInfo(
          id: popup,
          appName: "app_name_star",
          iconPath: Icons.star,
          size: new Size(700, 650),
          requiresLogin: true,
        );
        break;
      case PopupType.Coins:
        info = PopupInfo(
          id: popup,
          appName: "app_name_coins",
          iconPath: Icons.copyright,
          size: new Size(600, 650),
          requiresLogin: true,
        );
        break;
      case PopupType.Settings:
        info = PopupInfo(
          id: popup,
          appName: "app_name_settings",
          iconPath: Icons.settings,
          size: new Size(650, 400),
          requiresLogin: true,
        );
        break;
      case PopupType.MessengerChat:
        info = PopupInfo(
          id: popup,
          appName: "app_name_messengerChat",
          iconPath: Icons.chat_bubble,
          size: new Size(600, 460),
          requiresLogin: true,
        );
        break;
      case PopupType.Photos:
        info = PopupInfo(
          id: popup,
          appName: "app_name_photos",
          iconPath: Icons.photo_camera,
          size: new Size(600, 400),
          requiresLogin: true,
        );
        break;
      case PopupType.PhotoViewer:
        info = PopupInfo(
          id: popup,
          appName: "app_name_photoViewer",
          iconPath: Icons.photo_camera,
          size: new Size(600, 800),
          requiresLogin: true,
        );
        break;
      case PopupType.PhotoFileUpload:
        info = PopupInfo(
          id: popup,
          appName: "app_name_photo_file_upload",
          iconPath: Icons.add_photo_alternate_outlined,
          size: new Size(500, 205),
          requiresLogin: true,
        );
        break;
      case PopupType.PhotoCameraUpload:
        info = PopupInfo(
          id: popup,
          appName: "app_name_photo_camera_upload",
          iconPath: Icons.linked_camera,
          size: new Size(400, 600),
          requiresLogin: true,
        );
        break;
      case PopupType.Videos:
        info = PopupInfo(
          id: popup,
          appName: "app_name_videos",
          iconPath: Icons.video_collection,
          size: new Size(650, 500),
          requiresLogin: true,
        );
        break;
      case PopupType.SMSActivation:
        info = PopupInfo(
          id: popup,
          appName: "app_name_smsActivation",
          iconPath: Icons.phone,
          size: new Size(650, 470),
          requiresLogin: true,
        );
        break;
      case PopupType.ChatMasterBan:
        info = PopupInfo(
          id: popup,
          appName: "app_name_chatMasterBan",
          iconPath: Icons.block,
          size: new Size(300, 250),
          requiresLogin: true,
        );
        break;
      case PopupType.Gifts:
        info = PopupInfo(
          id: popup,
          appName: "app_name_gifts",
          iconPath: FontAwesomeIcons.gift,
          size: new Size(800, 440),
          requiresLogin: true,
        );
        break;
      case PopupType.Protector:
        info = PopupInfo(
          id: popup,
          appName: "app_name_protector",
          iconPath: FontAwesomeIcons.exclamationCircle,
          size: new Size(400, 300),
          requiresLogin: true,
        );
        break;
      default:
        throw new Exception("Unknown popup: $popup");
        break;
    }

    return info;
  }

  Widget getPopUpWidget(PopupType popup, OnCallbackAction callbackAction, Function(bool value) setBusy, BuildContext context, dynamic options) {
    Widget widget;
    var info = getPopUpInfo(popup);
    _popups[popup] = info;
    switch (popup) {
      case PopupType.Login:
        widget = Login(onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue), setBusy: (value) => setBusy(value));
        break;
      case PopupType.Signup:
        widget = Signup(onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue), setBusy: (value) => setBusy(value));
        break;
      case PopupType.Profile:
        widget = Profile(userId: options, size: info.size, onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue), setBusy: (value) => setBusy(value));
        break;
      case PopupType.Star:
        widget = Star(size: info.size);
        break;
      case PopupType.Coins:
        widget = Coins(size: info.size);
        break;
      case PopupType.Settings:
        widget = Settings(size: info.size, setBusy: (value) => setBusy(value));
        break;
      case PopupType.MessengerChat:
        widget = MessengerChat();
        break;
      case PopupType.Photos:
        widget = Photos(userId: options, size: info.size, setBusy: (value) => setBusy(value));
        break;
      case PopupType.PhotoViewer:
        widget = PhotoViewer(photoId: options, size: info.size);
        break;
      case PopupType.PhotoFileUpload:
        widget = PhotoFileUpload(info.size);
        break;
      case PopupType.PhotoCameraUpload:
        widget = PhotoCameraUpload(info.size);
        break;
      case PopupType.Videos:
        widget = Videos(username: options, size: info.size, setBusy: (value) => setBusy(value));
        break;
      case PopupType.SMSActivation:
        widget = SMSActivation(size: info.size, setBusy: (value) => setBusy(value));
        break;
      case PopupType.ChatMasterBan:
        widget = ChatMasterBan(onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue), username: options, size: info.size, setBusy: (value) => setBusy(value));
        break;
      case PopupType.Gifts:
        widget = Gifts(username: options, size: info.size, setBusy: (value) => setBusy(value));
        break;
      case PopupType.Protector:
        widget = Protector(costType: options, size: info.size, onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue));
        break;
      default:
        throw new Exception("Unknown popup: $popup");
        break;
    }

    return widget;
  }

  _closePopup(OnCallbackAction callbackAction, PopupType popup, BuildContext context, dynamic retValue) {
    if (_popups.containsKey(popup)) {
      _popups.remove(popup);
      print("PopupManager - closePopup: $popup - retValue: $retValue");
      Navigator.of(context, rootNavigator: true).pop();
    }
    if (_popups.length == 0 && AppProvider.instance.popupOverIFrameExists) AppProvider.instance.popupOverIFrameExists = false;
    if (retValue != null) {
      callbackAction(retValue);
    }
  }
}
