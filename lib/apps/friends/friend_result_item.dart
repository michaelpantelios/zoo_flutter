import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/friends/friend_info.dart';
import 'package:zoo_flutter/utils/utils.dart';

class FriendResultItem extends StatefulWidget {
  FriendResultItem({Key key}) : super(key: key);

  static double myWidth = 160;
  static double myHeight = 160;

  FriendResultItemState createState() => FriendResultItemState(key: key);
}

class FriendResultItemState extends State<FriendResultItem> {
  FriendResultItemState({Key key});

  bool _mouseOver = false;
  FriendInfo _data;

  String _username = "";
  dynamic _userId;
  dynamic _mainPhoto;
  dynamic _sex = 1;

  _openProfile(BuildContext context, int userId) {
    print("_openProfile " + userId.toString());
    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userId, callbackAction: (retValue) {});
  }

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
  void initState() {
    super.initState();
    // print("I am search item with data:");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _userId == null
        ? SizedBox(width: FriendResultItem.myWidth, height: FriendResultItem.myHeight)
        : MouseRegion(
            onEnter: (_) {
              setState(() {
                _mouseOver = true;
              });
            },
            onExit: (_) {
              setState(() {
                _mouseOver = false;
              });
            },
            child: Container(
              width: FriendResultItem.myWidth,
              height: FriendResultItem.myHeight,
              padding: EdgeInsets.all(5),
              child: Card(
                // margin: EdgeInsets.all(10),
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 60,
                      padding: EdgeInsets.all(5),
                      child: (_mainPhoto == null)
                          ? FaIcon(_sex == 4 ? FontAwesomeIcons.userFriends : Icons.face,
                              size: _sex == 4 ? 40 : 60,
                              color: _sex == 1
                                  ? Colors.blue
                                  : _sex == 2
                                      ? Colors.pink
                                      : Colors.green)
                          : Image.network(
                              Utils.instance.getUserPhotoUrl(photoId: _mainPhoto["image_id"].toString()),
                              width: 60,
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
                            _openProfile(context, int.parse(_userId.toString()));
                          },
                          child: Image.asset(
                            "assets/images/friends/profile_idle.png",
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("mail");
                          },
                          child: Image.asset(
                            "assets/images/friends/mail_idle.png",
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("send gift");
                          },
                          child: Image.asset(
                            "assets/images/friends/sendGift_idle.png",
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("remove friend");
                          },
                          child: Image.asset(
                            "assets/images/friends/removeFriend_idle.png",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
