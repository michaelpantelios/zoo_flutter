import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/user/user_info.dart';

class ChatUserRenderer extends StatefulWidget {
  final UserInfo userInfo;
  final Function(Offset rendererPosition, Size rendererSize) onMenu;
  final Function(String username) onSelected;
  final bool selected;

  ChatUserRenderer({Key key, @required this.userInfo, @required this.selected, @required this.onMenu, @required this.onSelected})
      : assert(userInfo != null),
        super(key: key);

  ChatUserRendererState createState() => ChatUserRendererState();
}

class ChatUserRendererState extends State<ChatUserRenderer> {
  ChatUserRendererState({Key key});

  bool _isOver = false;

  Offset rendererPosition;
  Size rendererSize;

  RenderBox renderBox;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    renderBox = context.findRenderObject();
  }

  findPosition() {
    rendererSize = renderBox.size;
    rendererPosition = renderBox.localToGlobal(Offset.zero);
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
        onTapUp: (e) {
          if (!widget.selected) return;
          print("onTapUp: ${widget.userInfo.username}");
          findPosition();
          widget.onMenu(rendererPosition, rendererSize);
        },
        child: Container(
            padding: EdgeInsets.only(top: 3, bottom: 3, right: 3),
            decoration: widget.selected
                ? BoxDecoration(
                    color: Color(0xffe4e6e9),
                  )
                : _isOver
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
                  Image.asset("assets/images/friends/${widget.userInfo.sex == 1 ? "male_avatar_small" : "female_avatar_small"}.png"),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      (widget.userInfo.isOper ? "@" : "") + widget.userInfo.username,
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
