import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class FriendRequestRenderer extends StatefulWidget {
  final UserInfo userInfo;
  final Function(String username) onSelected;
  final Function(String userId) onOpenProfile;
  final bool selected;
  final bool showOverState;
  final double overflowWidth;
  final Function onAccept;
  final Function onReject;
  final Function onBlock;

  FriendRequestRenderer({Key key, @required this.userInfo, @required this.selected, @required this.onSelected, @required this.onOpenProfile, this.showOverState = true, this.overflowWidth = 0, this.onAccept, this.onReject, this.onBlock})
      : assert(userInfo != null),
        super(key: key);

  _FriendRequestRendererState createState() => _FriendRequestRendererState();
}

class _FriendRequestRendererState extends State<FriendRequestRenderer> {
  _FriendRequestRendererState({Key key});

  bool _isOver = false;

  RenderBox renderBox;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) {
        setState(() {
          _isOver = true;
        });
      },
      onExit: (e) {
        setState(() {
          _isOver = false;
        });
      },
      child: GestureDetector(
        onTapDown: (e) {
          print("onTapDown: ${widget.userInfo.username}");
          widget.onSelected(widget.userInfo.username);
        },
        child: Container(
            padding: EdgeInsets.only(top: 3, bottom: 3, right: 3),
            decoration: widget.selected
                ? BoxDecoration(
                    color: Colors.orange,
                  )
                : _isOver && widget.showOverState
                    ? BoxDecoration(
                        color: Color(0xffe4e6e9),
                      )
                    : BoxDecoration(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/friends/${widget.userInfo.sex == 1 ? "male_avatar_small" : "female_avatar_small"}.png"),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: GestureDetector(
                          onTap: () {
                            widget.onOpenProfile(widget.userInfo.userId.toString());
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Text(
                              widget.userInfo.username,
                              style: TextStyle(
                                color: Color(0xff393e54),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      widget.userInfo.mainPhoto == null
                          ? Container()
                          : true
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 2, left: 8),
                                  child: Image.asset(
                                    "assets/images/friends/camera_icon.png",
                                    height: 15,
                                  ),
                                )
                              : Container(),
                      widget.userInfo.isStar
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 2, left: 8),
                              child: Image.asset(
                                "assets/images/friends/star_icon.png",
                                height: 15,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.onAccept(int.parse(widget.userInfo.userId.toString()));
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color(0xff64abff),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).translate("friend_accept"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onReject(int.parse(widget.userInfo.userId.toString()), widget.userInfo.username);
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color(0xffbabbbd),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).translate("friend_reject"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onBlock(int.parse(widget.userInfo.userId.toString()), widget.userInfo.username);
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color(0xffdc5b42),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/images/friends/ban_icon.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
