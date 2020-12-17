import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/profile/profile_basic.dart';
import 'package:zoo_flutter/apps/profile/profile_gift_thumb.dart';
import 'package:zoo_flutter/apps/profile/profile_gifts.dart';
import 'package:zoo_flutter/apps/profile/profile_photo_thumb.dart';
import 'package:zoo_flutter/apps/profile/profile_photos.dart';
import 'package:zoo_flutter/apps/profile/profile_video_thumb.dart';
import 'package:zoo_flutter/apps/profile/profile_videos.dart';

import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';

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


  onGetProfileView() {
    print (_profileInfo.user.username);
    setState(() {
      print("duh");
      dataReady = true;

      profileWidgets.add(ProfileBasic(profileInfo: _profileInfo, myWidth: widget.size.width - 10, isMe: isMe));

      profileWidgets.add(ProfilePhotos(userInfo: _profileInfo.user, myWidth: widget.size.width - 10, photosNum: _profileInfo.counters.photos, isMe: isMe));
      profileWidgets.add(ProfileVideos(userInfo: _profileInfo.user, myWidth: widget.size.width - 10, videosNum: _profileInfo.counters.videos, isMe: isMe));
      profileWidgets.add(ProfileGifts(userInfo: _profileInfo.user, myWidth: widget.size.width - 10, giftsNum: _profileInfo.counters.gifts, isMe: isMe));
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
    var res = await _rpc.callMethod("Profile.Main.getProfileInfo",  [_userId] );

    if (res["status"] == "ok") {
      print("res ok");
      _profileInfo = ProfileInfo.fromJSON(res["data"]);

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

    if (!UserProvider.instance.logged){
      print("not logged");
    } else {
      print("logged");

      _userId = widget.userId;
      if (_userId == null){
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
        : Container(
            padding: EdgeInsets.all(5),
            color: Theme.of(context).canvasColor,
            height: widget.size.height - 5,
            width: widget.size.width-5,
            child: Scrollbar(
              child: ListView(shrinkWrap: true, children: profileWidgets)
            ),
          );
  }
}
