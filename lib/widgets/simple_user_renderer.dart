import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/user/user_info.dart';

class SimpleUserRenderer extends StatefulWidget {
  final UserInfo userInfo;
  final Function(String username) onSelected;
  final Function(String userId) onOpenProfile;
  final bool selected;
  final bool showOverState;

  SimpleUserRenderer({
    Key key,
    @required this.userInfo,
    @required this.selected,
    @required this.onSelected,
    @required this.onOpenProfile,
    this.showOverState = true,
  })  : assert(userInfo != null),
        super(key: key);

  _SimpleUserState createState() => _SimpleUserState();
}

class _SimpleUserState extends State<SimpleUserRenderer> {
  _SimpleUserState({Key key});

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
                    color: Color(0xffe4e6e9),
                  )
                : _isOver && widget.showOverState
                    ? BoxDecoration(
                        color: Color(0xfff8f8f9),
                      )
                    : BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/friends/${int.parse(widget.userInfo.sex.toString()) == 1 ? "male_avatar_small" : "female_avatar_small"}.png"),
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
                          maxLines: 1,
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
            )),
      ),
    );
  }
}
