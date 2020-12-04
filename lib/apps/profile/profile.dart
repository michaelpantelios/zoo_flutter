import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/models/user/user_info_model.dart';
import 'package:zoo_flutter/control/user.dart';
import 'package:zoo_flutter/apps/profile/profile_basic.dart';
import 'package:zoo_flutter/apps/profile/profile_photos.dart';
import 'package:zoo_flutter/apps/profile/profile_photo_thumb.dart';
import 'package:zoo_flutter/apps/profile/profile_videos.dart';
import 'package:zoo_flutter/apps/profile/profile_video_thumb.dart';
import 'package:zoo_flutter/apps/profile/profile_gifts.dart';
import 'package:zoo_flutter/apps/profile/profile_gift_thumb.dart';

class Profile extends StatefulWidget {
  Profile();

  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  ProfileState();

  Size _appSize = DataMocker.apps["profile"].size;
  UserInfoModel user = User.instance.userInfo;
  UserInfoModel sender = DataMocker.users.where((user) => user.userId == 7).first;
  bool isMe = false;
  List<Widget> profileWidgets;
  bool dataReady = false;


  _simulateServiceResponder(_) {
    setState(() {
      print("duh");
      dataReady = true;

      profileWidgets.add(ProfileBasic(userData: user, myWidth: _appSize.width - 10, isMe: isMe, isOnline: user.isOnline));

      List<ProfilePhotoThumbData> photosList = new List<ProfilePhotoThumbData>();
      for (int i=0; i< 20; i++)
        photosList.add(new ProfilePhotoThumbData(url: "https://ik.imagekit.io/bugtown/userphotos/testing/237e51c6142589e9333258ebda2f2f09.png"));

      List<ProfileVideoThumbData> videosList = new List<ProfileVideoThumbData>();
      for (int i=0; i< 17; i++)
       videosList.add(new ProfileVideoThumbData(url: "https://ik.imagekit.io/bugtown/userphotos/testing/b643ff5523c29138a9efafa271599a27.png"));

      List<ProfileGiftThumbData> giftsList = new List<ProfileGiftThumbData>();
      for (int i=0; i<20; i++)
        giftsList.add(new ProfileGiftThumbData(path: "images/gifts/"+(i+50).toString()+"-icon.png", senderId: sender.userId, sex: sender.sex, username: sender.username, photoUrl: sender.photoUrl ));

      profileWidgets.add( ProfilePhotos(photosData: photosList, myWidth: _appSize.width - 10, username: user.username, isMe: isMe));
      profileWidgets.add( ProfileVideos(videosData: videosList, myWidth: _appSize.width - 10, username: user.username, isMe: isMe));
      profileWidgets.add( ProfileGifts(giftsData: giftsList, myWidth: _appSize.width - 10, username: user.username, isMe: isMe));

    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_simulateServiceResponder);
    profileWidgets = new List<Widget>();

  }

  @override
  Widget build(BuildContext context) {
    return !dataReady ? Container() : Container(
      color: Theme.of(context).canvasColor,
      height: _appSize.height - 4,
      width: _appSize.width,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(5.0),
        children: profileWidgets
      ),
    );
  }
}
