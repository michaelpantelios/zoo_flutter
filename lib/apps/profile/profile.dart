import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/profile/photos/profile_photos.dart';
import 'package:zoo_flutter/apps/profile/profile_basic.dart';
import 'package:zoo_flutter/apps/profile/videos/profile_videos.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/apps/profile/profile_edit.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'gifts/profile_gifts.dart';

class Profile extends StatefulWidget {
  final int userId;
  final Size size;
  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;
  Profile({this.userId, @required this.size, this.onClose, this.setBusy});

  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  ProfileState();

  int _userId;
  bool isMe = false;
  List<Widget> profileWidgets;
  bool dataReady = false;
  ProfileInfo _profileInfo;
  RPC _rpc;
  double _editProfileOpacity = 0;


  GlobalKey<ProfileEditState> _profileEditKey = GlobalKey<ProfileEditState>();

  _onEditProfileClose() {
    setState(() {
      _editProfileOpacity = 0;
    });
  }

  _onEditProfileComplete(BuildContext context, dynamic data) async {
    var res = await _rpc.callMethod("Zoo.Account.updateBasicInfo", [data]);

    if (res["status"] == "ok") {
      print("Edit Profile Complete");
      AlertManager.instance.showSimpleAlert(context: context,
          bodyText: AppLocalizations.of(context).translate("app_profile_edit_basicInfoUpdateComplete"));
    } else {
      print("ERROR");
      print(res);
    }

      //todo call service to save data;
      _editProfileOpacity = 0;

  }

  _onOpenEditProfile() {
    setState(() {
      _profileEditKey.currentState.update(_profileInfo);
      _editProfileOpacity = 1;
    });
  }


  onGetProfileView() {
    setState(() {
      print("duh");
      profileWidgets.add(ProfileBasic(profileInfo: _profileInfo, myWidth: widget.size.width, isMe: isMe, onOpenEditProfile: _onOpenEditProfile));

      profileWidgets.add(ProfilePhotos(userInfo: _profileInfo.user, myWidth: widget.size.width - 10, photosNum: _profileInfo.counters.photos, isMe: isMe));
      profileWidgets.add(ProfileVideos(userInfo: _profileInfo.user, myWidth: widget.size.width - 10, videosNum: _profileInfo.counters.videos, isMe: isMe));
      profileWidgets.add(ProfileGifts(userInfo: _profileInfo.user, myWidth: widget.size.width - 10, giftsNum: _profileInfo.counters.gifts, isMe: isMe));

      dataReady = true;
    });
  }

  @override
  void initState() {
    _rpc = RPC();
    print("profile - initState");
    profileWidgets = new List<Widget>();

    super.initState();
  }

  getProfileInfo() async {
    var res = await _rpc.callMethod("Profile.Main.getProfileInfo", [_userId]);

    if (res["status"] == "ok") {
      print("res ok");
      _profileInfo = ProfileInfo.fromJSON(res["data"]);
      print("_profileInfo = ");
      print(res["data"]);
      onGetProfileView();
    } else {
      print("ERROR");
      print(res["status"]);
    }

    return res;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (!UserProvider.instance.logged) {
      print("not logged");
    } else {
      print("logged");

      _userId = widget.userId;
      if (_userId == null) {
        _userId = UserProvider.instance.userInfo.userId;
        isMe = true;
      }

      var res = getProfileInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return !dataReady
        ? Container()
        : Stack(
      children: [
        Center(child:
          Container(
            padding: EdgeInsets.all(5),
            color: Color(0xFFffffff),
            height: widget.size.height - 5,
            width: widget.size.width - 5,
            child: Scrollbar(child: ListView(shrinkWrap: true, children: profileWidgets)),
          )
        ),
        Opacity(
          opacity : _editProfileOpacity, // _editProfileVisible,
          child: Center(
              child: ProfileEdit(
                  key: _profileEditKey,
                  onCloseHandler: _onEditProfileClose,
                  onEditCompleteHandler: _onEditProfileComplete
                   ))
        )
      ],
    );
  }
}
