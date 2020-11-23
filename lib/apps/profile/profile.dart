import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/models/user/user_info_model.dart';
import 'package:zoo_flutter/control/user.dart';
import 'package:zoo_flutter/apps/profile/profile_basic.dart';
import 'package:zoo_flutter/apps/profile/profile_photos.dart';
import 'package:zoo_flutter/apps/profile/profile_photo_thumb.dart';
import 'package:zoo_flutter/apps/profile/profile_videos.dart';
import 'package:zoo_flutter/apps/profile/profile_gifts.dart';

class Profile extends StatefulWidget {
  Profile();

  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  ProfileState();

  Size _appSize = DataMocker.apps["profile"].size;
  UserInfoModel user = User.instance.userInfo;
  bool isMe = false;

  GlobalKey<ProfileBasicState> profileBasicKey;
  GlobalKey<ProfilePhotosState> profilePhotosKey;
  GlobalKey<ProfileVideosState> profileVideosKey;
  GlobalKey<ProfileGiftsState> profileGiftsKey;

  _simulateServiceResponder(_) {
      profileBasicKey.currentState.updateData(user);

      List<ProfilePhotoThumbData> photosList = new List<ProfilePhotoThumbData>();

      for (int i=0; i< 20; i++)
        photosList.add(new ProfilePhotoThumbData(url: "https://ik.imagekit.io/bugtown/userphotos/testing/237e51c6142589e9333258ebda2f2f09.png"));

      profilePhotosKey.currentState.updateData(photosList);
      profileVideosKey.currentState.updateData(new List<ProfileVideoModel>());
      profileGiftsKey.currentState.updateData(new List<ProfileGiftModel>());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_simulateServiceResponder);

    profileBasicKey = new GlobalKey<ProfileBasicState>();
    profilePhotosKey = new GlobalKey<ProfilePhotosState>();
    profileVideosKey = new GlobalKey<ProfileVideosState>();
    profileGiftsKey = new GlobalKey<ProfileGiftsState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      height: _appSize.height - 4,
      width: _appSize.width,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(5.0),
        children: <Widget>[
          ProfileBasic(key: profileBasicKey, myWidth: _appSize.width - 10, isMe: isMe,),
          ProfilePhotos(key: profilePhotosKey, myWidth: _appSize.width - 10, username: user.username, isMe: isMe),
          ProfileVideos(key: profileVideosKey, myWidth: _appSize.width - 10, username: user.username, isMe: isMe),
          ProfileGifts(key: profileGiftsKey, myWidth: _appSize.width - 10, username: user.username, isMe: isMe)
        ],
      ),
    );
  }
}
