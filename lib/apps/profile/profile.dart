import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/profile/profile_basic.dart';
import 'package:zoo_flutter/apps/profile/profile_gift_thumb.dart';
import 'package:zoo_flutter/apps/profile/profile_gifts.dart';
import 'package:zoo_flutter/apps/profile/profile_photo_thumb.dart';
import 'package:zoo_flutter/apps/profile/profile_photos.dart';
import 'package:zoo_flutter/apps/profile/profile_video_thumb.dart';
import 'package:zoo_flutter/apps/profile/profile_videos.dart';
import 'package:zoo_flutter/control/user.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/user/user_info_model.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/net/rpc.dart';

class Profile extends StatefulWidget {
  final Size size;
  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;
  Profile({@required this.size, this.onClose, this.setBusy});

  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  ProfileState();

  UserInfoModel user = User.instance.userInfo;
  UserInfoModel sender = DataMocker.users.where((user) => user.userId == 7).first;
  bool isMe = false;
  List<Widget> profileWidgets;
  bool dataReady = false;
  RPC _rpc;

  onGetProfileView(data) {
    print(data);
    print ("gotProfileInfo");
    // setState(() {
    //   print("duh");
    //   dataReady = true;
    //
    //   profileWidgets.add(ProfileBasic(userData: user, myWidth: widget.size.width - 10, isMe: isMe, isOnline: user.isOnline));
    //
    //   List<ProfilePhotoThumbData> photosList = new List<ProfilePhotoThumbData>();
    //   for (int i = 0; i < 20; i++) photosList.add(new ProfilePhotoThumbData(url: "https://ik.imagekit.io/bugtown/userphotos/testing/237e51c6142589e9333258ebda2f2f09.png"));
    //
    //   List<ProfileVideoThumbData> videosList = new List<ProfileVideoThumbData>();
    //   for (int i = 0; i < 17; i++) videosList.add(new ProfileVideoThumbData(url: "https://ik.imagekit.io/bugtown/userphotos/testing/b643ff5523c29138a9efafa271599a27.png"));
    //
    //   List<ProfileGiftThumbData> giftsList = new List<ProfileGiftThumbData>();
    //   for (int i = 0; i < 20; i++) giftsList.add(new ProfileGiftThumbData(path: "images/gifts/" + (i + 50).toString() + "-icon.png", senderId: sender.userId, sex: sender.sex, username: sender.username, photoUrl: sender.photoUrl));
    //
    //   profileWidgets.add(ProfilePhotos(photosData: photosList, myWidth: widget.size.width - 10, username: user.username, isMe: isMe));
    //   profileWidgets.add(ProfileVideos(videosData: videosList, myWidth: widget.size.width - 10, username: user.username, isMe: isMe));
    //   profileWidgets.add(ProfileGifts(giftsData: giftsList, myWidth: widget.size.width - 10, username: user.username, isMe: isMe));
    // });
  }

  @override
  void initState() {
    _rpc = RPC();
    print("profile - initState");
    // profileWidgets = new List<Widget>();
    super.initState();
  }


  getProfileInfo() async {
    print("getProfileInfo");
    print("userId: "+UserProvider.instance.loginData.userId.toString());
    var res = await _rpc.callMethod("Profile.Main.getProfileInfo", [ UserProvider.instance.loginData.userId ]);

    if (res["status"] == "ok") {
      print("res ok");
      onGetProfileView(res["data"]);
    } else {
      print("fuckme");
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
      widget.onClose(null);
      // PopupManager.instance.show(
      //   context: context,
      //   popup: PopupType.Login,
      //   callbackAction: (retValue) {
      //     print(retValue);
      //   },
      // )
      return;
    } else {
      print("logged");


     var res = getProfileInfo();


    }

  }

  @override
  Widget build(BuildContext context) {
    return !dataReady
        ? Container()
        : Container(
            color: Theme.of(context).canvasColor,
            height: widget.size.height - 4,
            width: widget.size.width,
            child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(5.0), children: profileWidgets),
          );
  }
}
