import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/friends/friend_info.dart';
import 'package:zoo_flutter/utils/utils.dart';

class FriendResultItem extends StatefulWidget {
  final Function openProfile;
  final Function openMail;
  final Function sendGift;
  final Function removeFriend;

  FriendResultItem({Key key, this.openProfile, this.openMail, this.sendGift, this.removeFriend}) : super(key: key);

  static double myWidth = 160;
  static double myHeight = 160;

  FriendResultItemState createState() => FriendResultItemState(key: key);
}

class FriendResultItemState extends State<FriendResultItem> {
  FriendResultItemState({Key key});

  String _username = "";
  dynamic _userId;
  dynamic _mainPhoto;
  dynamic _sex = 1;

  update(FriendInfo data) {
    setState(() {
      _userId = data.user.userId;
      _username = data.user.username;
      _mainPhoto = data.user.mainPhoto;
      _sex = data.user.sex;
    });
  }

  clear() {
    setState(() {
      _userId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _userId == null
        ? SizedBox(width: FriendResultItem.myWidth, height: FriendResultItem.myHeight)
        : Container(
            width: FriendResultItem.myWidth,
            height: FriendResultItem.myHeight,
            padding: EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xaa000000),
                    offset: new Offset(0, 0),
                    blurRadius: 1,
                    spreadRadius: 0.2,
                  ),
                ],
                border: Border.all(color: Color(0xffcacaca)),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipOval(
                    child: _mainPhoto != null
                        ? Image.network(
                            Utils.instance.getUserPhotoUrl(photoId: _mainPhoto["image_id"].toString()),
                            height: 75,
                            width: 75,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Color(0xff393E54),
                            child: Image.asset(
                              _sex == 1 ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png",
                              height: 75,
                              width: 75,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),
                          child: Text(
                            _username,
                            style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.openProfile(int.parse(_userId.toString()));
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Image.asset(
                            "assets/images/friends/profile_idle.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("mail");
                          widget.openMail(_username);
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Image.asset(
                            "assets/images/friends/mail_idle.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("send gift");
                          widget.sendGift(_username);
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Image.asset(
                            "assets/images/friends/sendGift_idle.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("remove friend");
                          widget.removeFriend(_username, int.parse(_userId.toString()));
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Image.asset(
                            "assets/images/friends/removeFriend_idle.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
