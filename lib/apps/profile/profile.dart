import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/profile/photos/profile_photos.dart';
import 'package:zoo_flutter/apps/profile/profile_basic.dart';
import 'package:zoo_flutter/apps/profile/edit/profile_edit.dart';
import 'package:zoo_flutter/apps/profile/videos/profile_videos.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/widgets/draggable_scrollbar.dart';

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
  ScrollController _scrollController;

  GlobalKey<ProfileBasicState> _profileBasicKey = GlobalKey<ProfileBasicState>();

  onUpdateBasicProfile(){
    getProfileInfo(update: true);
  }

  onGetProfileView() {
    setState(() {
      print("duh");
      profileWidgets.add(ProfileBasic(key: _profileBasicKey, profileInfo: _profileInfo, myWidth: widget.size.width, isMe: isMe, onUpdateHandler: onUpdateBasicProfile));

      profileWidgets.add(ProfilePhotos(userInfo: _profileInfo.user, myWidth: widget.size.width - 10, photosNum: _profileInfo.counters.photos, isMe: isMe));
      // profileWidgets.add(ProfileVideos(userInfo: _profileInfo.user, myWidth: widget.size.width - 10, videosNum: _profileInfo.counters.videos, isMe: isMe));
      profileWidgets.add(ProfileGifts(userInfo: _profileInfo.user, myWidth: widget.size.width - 10, giftsNum: _profileInfo.counters.gifts, isMe: isMe));

      dataReady = true;
    });
  }

  @override
  void initState() {
    _rpc = RPC();
    _scrollController = ScrollController();
    print("profile - initState");
    profileWidgets = [];

    if (!UserProvider.instance.logged) {
      print("not logged");
    } else {
      print("logged");

      _userId = widget.userId;
      if (_userId == null) {
        _userId = UserProvider.instance.userInfo.userId;
        isMe = true;
      } else {
        isMe = _userId == UserProvider.instance.userInfo.userId;
      }

      var res = getProfileInfo();
    }

    super.initState();
  }

  getProfileInfo({bool update = false}) async {
    var res = await _rpc.callMethod("Profile.Main.getProfileInfo", [_userId]);

    if (res["status"] == "ok") {
      print("res ok");
      _profileInfo = ProfileInfo.fromJSON(res["data"]);
      // print("_profileInfo = ");
      print(res["data"]);
      if (!update)
        onGetProfileView();
      else {
        _profileBasicKey.currentState.update(_profileInfo);
      }
    } else {
      print("ERROR");
      print(res["status"]);
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return !dataReady
        ? Container()
        : Center(
            child: Container(
            padding: EdgeInsets.all(5),
            color: Color(0xFFffffff),
            height: widget.size.height - 5,
            width: widget.size.width - 5,
            child: DraggableScrollbar(
                heightScrollThumb: 100,
                controller: _scrollController,
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(padding: EdgeInsets.only(right: 9), child:Column(children: profileWidgets) )
                )
            ),
          ));
  }
}
