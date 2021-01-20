import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:zoo_flutter/apps/chat/chat_master_ban.dart';
import 'package:zoo_flutter/apps/coins/coins.dart';
import 'package:zoo_flutter/apps/contact/contact.dart';
import 'package:zoo_flutter/apps/friends/friends.dart';
import 'package:zoo_flutter/apps/gifts/gifts.dart';
import 'package:zoo_flutter/apps/login/login.dart';
import 'package:zoo_flutter/apps/mail/mail.dart';
import 'package:zoo_flutter/apps/mail/mail_new.dart';
import 'package:zoo_flutter/apps/mail/mail_reply.dart';
import 'package:zoo_flutter/apps/messenger/messenger_chat.dart';
import 'package:zoo_flutter/apps/photos/photo_camera_upload.dart';
import 'package:zoo_flutter/apps/photos/photo_file_upload.dart';
import 'package:zoo_flutter/apps/photoviewer/photo_viewer.dart';
import 'package:zoo_flutter/apps/photos/photos.dart';
import 'package:zoo_flutter/apps/profile/profile.dart';
import 'package:zoo_flutter/apps/profile/profile_edit.dart';
import 'package:zoo_flutter/apps/protector/protector.dart';
import 'package:zoo_flutter/apps/settings/settings.dart';
import 'package:zoo_flutter/apps/signup/signup.dart';
import 'package:zoo_flutter/apps/sms/SMSActivation.dart';
import 'package:zoo_flutter/apps/star/star.dart';
import 'package:zoo_flutter/apps/videos/videos.dart';
import 'package:zoo_flutter/apps/zoomaniacs/zoomaniacs.dart';
import 'package:zoo_flutter/apps/statistics/statistics.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

import '../main.dart';

enum PopupType {
  Login,
  Signup,
  Profile,
  ProfileEdit,
  Star,
  Coins,
  Settings,
  MessengerChat,
  Photos,
  PhotoViewer,
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
  Statistics
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
    @required this.iconPath,
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
      backgroundColor: Colors.white,
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
    print(popupInfo.id);
    if (!UserProvider.instance.logged && popupInfo.requiresLogin) {
      popupInfo = getPopUpInfo(PopupType.Login);
    }

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
    PopupInfo info;
    switch (popup) {
      case PopupType.Login:
        info = PopupInfo(
          id: popup,
          appName: "app_name_login",
          iconPath: FontAwesomeIcons.userCircle,
          size: new Size(640, 480),
          requiresLogin: false,
        );
        break;
      case PopupType.Signup:
        info = PopupInfo(
          id: popup,
          appName: "app_name_signup",
          iconPath: Icons.edit,
          size: new Size(600, 670),
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
      case PopupType.ProfileEdit:
        info = PopupInfo(
          id: popup,
          appName: "app_name_profileEdit",
          iconPath: Icons.edit,
          size: new Size(300, 300),
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
          iconImagePath: "assets/images/coins/coin_icon.png",
          size: new Size(600, 650),
          requiresLogin: true,
        );
        break;
      case PopupType.Settings:
        info = PopupInfo(
          id: popup,
          appName: "app_name_settings",
          iconPath: Icons.settings,
          size: new Size(690, 630),
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
          size: new Size(900, 600),
          requiresLogin: true,
        );
        break;
      case PopupType.PhotoViewer:
        info = PopupInfo(
          id: popup,
          appName: "app_name_photoViewer",
          iconPath: Icons.photo_camera,
          size: new Size(800, 800),
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
          size: new Size(900, 460),
          requiresLogin: true,
        );
        break;
      case PopupType.Mail:
        info = PopupInfo(
          id: popup,
          appName: "app_name_mail",
          iconPath: Icons.mail,
          size: new Size(750, 710),
          requiresLogin: true,
        );
        break;
      case PopupType.MailNew:
        info = PopupInfo(
          id: popup,
          appName: "mail_btnNew",
          iconPath: Icons.notes,
          size: new Size(580, 330),
          requiresLogin: true,
        );
        break;
      case PopupType.MailReply:
        info = PopupInfo(
          id: popup,
          appName: "mail_btnReply",
          iconPath: FontAwesomeIcons.reply,
          size: new Size(580, 590),
          requiresLogin: true,
        );
        break;
      case PopupType.Friends:
        info = PopupInfo(
          id: popup,
          appName: "mail_lblMyFriends",
          iconPath: FontAwesomeIcons.userFriends,
          size: new Size(675, 566),
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
      case PopupType.Contact:
        info = PopupInfo(
          id: popup,
          appName: "app_name_contact",
          iconPath: Icons.help,
          size: new Size(400, 380),
          requiresLogin: true,
        );
        break;
      case PopupType.ZooManiacs:
        info = PopupInfo(
          id: popup,
          appName: "app_name_zoomaniacs",
          iconPath: FontAwesomeIcons.grinStars,
          iconImagePath: "assets/images/zoomaniacs/maniac_icon.png",
          size: new Size(940, 800),
          requiresLogin: true,
        );
        break;
      case PopupType.Statistics:
        info = PopupInfo(
          id: popup,
          appName: "app_name_statistics",
          iconPath: FontAwesomeIcons.grinStars,
          iconImagePath: "assets/images/statistics/stats_icon.png",
          size: new Size(940, 800),
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
        widget = Settings(size: info.size, options: options, setBusy: (value) => setBusy(value));
        break;
      case PopupType.MessengerChat:
        widget = MessengerChat();
        break;
      case PopupType.Photos:
        widget = Photos(userId: options, size: info.size, setBusy: (value) => setBusy(value));
        break;
      case PopupType.PhotoViewer:
        widget = PhotoViewer(data: options, size: info.size, setBusy: (value) => setBusy(value), onClose: (retValue) => _closePopup(callbackAction, popup, context, retValue));
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
    // if (retValue != null) {
    callbackAction(retValue);
    // }
  }
}
