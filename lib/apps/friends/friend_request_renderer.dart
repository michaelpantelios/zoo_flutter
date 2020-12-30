import 'package:flutter/material.dart';
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
                        color: Colors.orange.shade50,
                      )
                    : BoxDecoration(),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.face, color: widget.userInfo.sex == 1 ? Colors.blue : Colors.pink, size: 22),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () {
                          widget.onOpenProfile(widget.userInfo.userId.toString());
                        },
                        child: widget.overflowWidth > 0
                            ? Container(
                                width: widget.overflowWidth,
                                child: Text(
                                  widget.userInfo.username,
                                  style: Theme.of(context).textTheme.headline6,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : Container(
                                child: Text(
                                  widget.userInfo.username,
                                  style: Theme.of(context).textTheme.headline6,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                      ),
                    ),
                    widget.userInfo.mainPhoto == null ? Container() : Icon(Icons.camera_alt, color: Colors.blueAccent, size: 20),
                    widget.userInfo.isStar ? Icon(Icons.star, color: Colors.yellow, size: 18) : Container(),
                  ],
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
                        child: Text(
                          AppLocalizations.of(context).translate("friend_accept"),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onReject(int.parse(widget.userInfo.userId.toString()), widget.userInfo.username);
                        },
                        child: Text(
                          AppLocalizations.of(context).translate("friend_reject"),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onBlock(int.parse(widget.userInfo.userId.toString()), widget.userInfo.username);
                        },
                        child: Text(
                          AppLocalizations.of(context).translate("friend_block"),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
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
