import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:zoo_flutter/apps/chat/chat_master_ban.dart';
import 'package:zoo_flutter/apps/coins/coins.dart';
import 'package:zoo_flutter/apps/contact/contact.dart';
import 'package:zoo_flutter/apps/facebook/facebook_linker.dart';
import 'package:zoo_flutter/apps/friends/friends.dart';
import 'package:zoo_flutter/apps/gifts/gifts.dart';
import 'package:zoo_flutter/apps/login/login.dart';
import 'package:zoo_flutter/apps/mail/mail.dart';
import 'package:zoo_flutter/apps/mail/mail_new.dart';
import 'package:zoo_flutter/apps/mail/mail_reply.dart';
import 'package:zoo_flutter/apps/messenger/messenger.dart';
import 'package:zoo_flutter/apps/photos/photo_camera_upload.dart';
import 'package:zoo_flutter/apps/photos/photo_file_upload.dart';
import 'package:zoo_flutter/apps/photos/photos.dart';
import 'package:zoo_flutter/apps/photoviewer/photo_viewer.dart';
import 'package:zoo_flutter/apps/pointshistory/points_history.dart';
import 'package:zoo_flutter/apps/profile/profile.dart';
import 'package:zoo_flutter/apps/profile/edit/profile_edit.dart';
import 'package:zoo_flutter/apps/protector/protector.dart';
import 'package:zoo_flutter/apps/settings/settings.dart';
import 'package:zoo_flutter/apps/signup/signup_zoo.dart';
import 'package:zoo_flutter/apps/signup/signup.dart';
import 'package:zoo_flutter/apps/sms/SMSActivation.dart';
import 'package:zoo_flutter/apps/star/star.dart';
import 'package:zoo_flutter/apps/statistics/statistics.dart';
import 'package:zoo_flutter/apps/videos/videos.dart';
import 'package:zoo_flutter/apps/videoviewer/video_viewer.dart';
import 'package:zoo_flutter/apps/zoomaniacs/zoomaniacs.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/main.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

enum PopupType {
  Login,
  Signup,
  SignupZoo,
  Profile,
  ProfileEdit,
  Star,
  Coins,
  Settings,
  MyPhotos,
  PhotoViewer,
  VideoViewer,
  PhotoFileUpload,
  PhotoCameraUpload,
  Videos,
  SMSActivation,
  ChatMasterBan,
  Gifts,
  Mail,
  MailNew,
  MailReply,
  Friends,
  Protector,
  Contact,
  ZooManiacs,
  Statistics,
  FacebookLinker,
  PointsHistory,
}

class PopupInfo {
  final PopupType id;
  final String appName;
  final IconData iconPath;
  final String iconImagePath;
  final Size size;
  final bool requiresLogin;

  PopupInfo({
    @required this.id,
    @required this.appName,
    this.iconPath,
    @required this.iconImagePath,
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
  final String headerOptions;
  GeneralDialog(this.popupInfo, this.onCallback, this.context, this.options, this.headerOptions);
  @override
  _GeneralDialogState createState() => _GeneralDialogState();
}

class _GeneralDialogState extends State<GeneralDialog> {
  Widget _dialogWidget;
  bool _busy = false;

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
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9.0),
      ),
      elevation: 10,
      contentPadding: EdgeInsets.zero,
      children: [
        PopupContainerBar(
          title: widget.popupInfo.appName,
          headerOptions: widget.headerOptions,
          iconData: widget.popupInfo.iconPath,
          iconImagePath: widget.popupInfo.iconImagePath,
          onClose: () => widget.onCallback(null),
        ),
        SizedBox(
          width: widget.popupInfo.size.width,
          height: widget.popupInfo.size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(color: Theme.of(context).backgroundColor, shape: BoxShape.rectangle, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9.0), bottomRight: Radius.circular(9.0))),
                child: _dialogWidget,
              ),
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

  Future<dynamic> show({@required context, @required PopupType popup, @required OnCallbackAction callbackAction, dynamic options, dynamic headerOptions, content, overlayColor = Colors.transparent}) async {
    var popupInfo = getPopUpInfo(popup);
    if (!UserProvider.instance.logged && popupInfo.requiresLogin) {
      popupInfo = getPopUpInfo(PopupType.Login);
    }

    Root.feedsManager.hide();

    return await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return PointerInterceptor(
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(width: double.infinity, height: double.infinity),
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: GeneralDialog(popupInfo, (retValue) => _closePopup(callbackAction, popup, buildContext, retValue), buildContext, options, headerOptions),
              ),
            ),
          ),
        );
      },
      barrierDismissible: false,
      barrierColor: overlayColor,
      useRootNavigator: true,
      transitionDuration: Duration(milliseconds: 0),
    );
  }

  PopupInfo getPopUpInfo(PopupType popup) {
    var prefix = "assets/images/popup_app_icons";
    PopupInfo info;
    switch (popup) {
      case PopupType.Login:
        info = PopupInfo(
          id: popup,
          appName: "app_name_login",
          iconImagePath: "$prefix/login_icon.png",
          size: new Size(640, 480),
          requiresLogin: false,
        );
        break;
      case PopupType.Signup:
        info = PopupInfo(
          id: popup,
          appName: "app_name_signup",
          iconImagePath: "$prefix/signup_icon.png",
          size: new Size(590, 330),
          requiresLogin: false,
        );
        break;
      case PopupType.SignupZoo:
        info = PopupInfo(
          id: popup,
          appName: "app_name_signup",
          iconImagePath: "$prefix/signup_icon.png",
          size: new Size(620, 670),
          requiresLogin: false,
        );
        break;
      case PopupType.Profile:
        info = PopupInfo(
          id: popup,
          appName: "app_name_profile",
          iconImagePath: "$prefix/profile_icon.png",
          size: new Size(700, 800),
          requiresLogin: true,
        );
        break;
      case PopupType.ProfileEdit:
        info = PopupInfo(
          id: popup,
          appName: "app_name_profileEdit",
          iconImagePath: "$prefix/profile_icon.png",
          size: new Size(500, 270),
          requiresLogin: true,
        );
        break;
      case PopupType.Star:
        info = PopupInfo(
          id: popup,
          appName: "app_name_star",
          iconImagePath: "$prefix/star_icon.png",
          size: new Size(630, 650),
          requiresLogin: true,
        );
        break;
      case PopupType.Coins:
        info = PopupInfo(
          id: popup,
          appName: "app_name_coins",
          iconImagePath: "$prefix/coins_icon.png",
          size: new Size(600, 730),
          requiresLogin: true,
        );
        break;
      case PopupType.Settings:
        info = PopupInfo(
          id: popup,
          appName: "app_name_settings",
          iconImagePath: "$prefix/settings_icon.png",
          size: new Size(690, 630),
          requiresLogin: true,
        );
        break;
      case PopupType.MyPhotos:
        info = PopupInfo(
          id: popup,
          appName: "app_name_photos",
          iconImagePath: "$prefix/myphotos_icon.png",
          size: new Size(900, 600),
          requiresLogin: true,
        );
        break;
      case PopupType.PhotoViewer:
        info = PopupInfo(
          id: popup,
          appName: "app_name_photoViewer",
          iconImagePath: "$prefix/myphotos_icon.png",
          size: new Size(800, 800),
          requiresLogin: true,
        );
        break;
      case PopupType.VideoViewer:
        info = PopupInfo(
          id: popup,
          appName: "app_name_videoViewer",
          iconImagePath: "$prefix/myvideos_icon.png",
          size: new Size(800, 800),
          requiresLogin: true,
        );
        break;
      case PopupType.PhotoFileUpload:
        info = PopupInfo(
          id: popup,
          appName: "app_name_photo_file_upload",
          iconImagePath: "$prefix/myphotos_icon.png",
          size: new Size(500, 205),
          requiresLogin: true,
        );
        break;
      case PopupType.PhotoCameraUpload:
        info = PopupInfo(
          id: popup,
          appName: "app_name_photo_camera_upload",
          iconImagePath: "$prefix/myphotos_icon.png",
          size: new Size(400, 600),
          requiresLogin: true,
        );
        break;
      case PopupType.Videos:
        info = PopupInfo(
          id: popup,
          appName: "app_name_videos",
          iconImagePath: "$prefix/myvideos_icon.png",
          size: new Size(900, 600),
          requiresLogin: true,
        );
        break;
      case PopupType.SMSActivation:
        info = PopupInfo(
          id: popup,
          appName: "app_name_smsActivation",
          iconImagePath: "$prefix/sms_activation_icon.png",
          size: new Size(650, 470),
          requiresLogin: true,
        );
        break;
      case PopupType.ChatMasterBan:
        info = PopupInfo(
          id: popup,
          appName: "app_name_chatMasterBan",
          iconImagePath: "$prefix/chat_ban_icon.png",
          size: new Size(300, 250),
          requiresLogin: true,
        );
        break;
      case PopupType.Gifts:
        info = PopupInfo(
          id: popup,
          appName: "app_name_gifts",
          iconImagePath: "$prefix/gifts_icon.png",
          size: new Size(900, 460),
          requiresLogin: true,
        );
        break;
      case PopupType.Mail:
        info = PopupInfo(
          id: popup,
          appName: "app_name_mail",
          iconImagePath: "$prefix/mail_icon.png",
          size: new Size(750, 710),
          requiresLogin: true,
        );
        break;
      case PopupType.MailNew:
        info = PopupInfo(
          id: popup,
          appName: "mail_btnNew",
          iconImagePath: "$prefix/mail_icon.png",
          size: new Size(580, 330),
          requiresLogin: true,
        );
        break;
      case PopupType.MailReply:
        info = PopupInfo(
          id: popup,
          appName: "mail_btnReply",
          iconImagePath: "$prefix/mail_icon.png",
          size: new Size(580, 590),
          requiresLogin: true,
        );
        break;
      case PopupType.Friends:
        info = PopupInfo(
          id: popup,
          appName: "mail_lblMyFriends",
          iconImagePath: "$prefix/friends_icon.png",
          size: new Size(675, 566),
          requiresLogin: true,
        );
        break;
      case PopupType.Protector:
        info = PopupInfo(
          id: popup,
          appName: "app_name_protector",
          iconImagePath: "$prefix/protector_icon.png",
          size: new Size(400, 300),
          requiresLogin: true,
        );
        break;
      case PopupType.Contact:
        info = PopupInfo(
          id: popup,
          appName: "app_name_contact",
          iconImagePath: "$prefix/contact_icon.png",
          size: new Size(400, 380),
          requiresLogin: true,
        );
        break;
      case PopupType.ZooManiacs:
        info = PopupInfo(
          id: popup,
          appName: "app_name_zoomaniacs",
          iconImagePath: "$prefix/zoomaniacs_icon.png",
          size: new Size(940, 800),
          requiresLogin: true,
        );
        break;
      case PopupType.Statistics:
        info = PopupInfo(
          id: popup,
          appName: "app_name_statistics",
          iconImagePath: "$prefix/stats_icon.png",
          size: new Size(940, 800),
          requiresLogin: true,
        );
        break;
      case PopupType.FacebookLinker:
        info = PopupInfo(
          id: popup,
          appName: "app_name_fblinker",
          iconImagePath: "$prefix/login_icon.png",
          size: new Size(500, 420),
          requiresLogin: false,
        );
        break;
      case PopupType.PointsHistory:
        info = PopupInfo(
          id: popup,
          appName: "app_name_pointshistory",
          iconImagePath: "$prefix/pointshistory_icon.png",
          size: new Size(650, 600),
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
        widget = Signup(size: info.size, onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue), setBusy: (value) => setBusy(value));
        break;
      case PopupType.SignupZoo:
        widget = SignupZoo(size: info.size, onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue), setBusy: (value) => setBusy(value));
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
        widget = Settings(size: info.size, options: options, setBusy: (value) => setBusy(value));
        break;
      case PopupType.MyPhotos:
        widget = Photos(userId: options, size: info.size, setBusy: (value) => setBusy(value));
        break;
      case PopupType.PhotoViewer:
        widget = PhotoViewer(data: options, size: info.size, setBusy: (value) => setBusy(value), onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue));
        break;
      case PopupType.VideoViewer:
        widget = VideoViewer(data: options, size: info.size, setBusy: (value) => setBusy(value), onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue));
        break;
      case PopupType.PhotoFileUpload:
        widget = PhotoFileUpload(size: info.size, customCallback: options, onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue), setBusy: (value) => setBusy(value));
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
      case PopupType.Mail:
        widget = Mail(size: info.size, setBusy: (value) => setBusy(value));
        break;
      case PopupType.MailNew:
        widget = MailNew(username: options, size: info.size, setBusy: (value) => setBusy(value), onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue));
        break;
      case PopupType.MailReply:
        widget = MailReply(mailMessageInfo: options, size: info.size, setBusy: (value) => setBusy(value), onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue));
        break;
      case PopupType.Friends:
        widget = Friends(size: info.size, setBusy: (value) => setBusy(value), onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue));
        break;
      case PopupType.Protector:
        widget = Protector(costType: options, size: info.size, onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue));
        break;
      case PopupType.Contact:
        widget = Contact(size: info.size, onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue), setBusy: (value) => setBusy(value));
        break;
      case PopupType.ProfileEdit:
        widget = ProfileEdit(profileInfo: options, size: info.size, onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue));
        break;
      case PopupType.ZooManiacs:
        widget = ZooManiacs(category: options, size: info.size);
        break;
      case PopupType.Statistics:
        widget = Statistics(size: info.size);
        break;
      case PopupType.FacebookLinker:
        widget = FacebookLinker(size: info.size, setBusy: (value) => setBusy(value), onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue));
        break;
      case PopupType.PointsHistory:
        widget = PointsHistory(size: info.size);
        break;
      default:
        throw new Exception("Unknown popup: $popup");
        break;
    }

    return widget;
  }

  _closePopup(OnCallbackAction callbackAction, PopupType popup, BuildContext context, dynamic retValue) {
    print("_closePopup");
    if (_popups.containsKey(popup)) {
      _popups.remove(popup);
      Navigator.of(context, rootNavigator: true).pop();
    }
    if (callbackAction != null) {
      callbackAction(retValue);
    }
  }

  popupIsOpen(PopupType popup) {
    return _popups.containsKey(popup);
  }
}
