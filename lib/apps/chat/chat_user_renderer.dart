import 'package:flutter/material.dart';
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
                    color: Colors.orange,
                  )
                : _isOver
                    ? BoxDecoration(
                        color: Colors.orange.shade50,
                      )
                    : BoxDecoration(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.face, color: widget.userInfo.sex == 1 ? Colors.blue : Colors.pink, size: 22),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      (widget.userInfo.isOper ? "@" : "") + widget.userInfo.username,
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      textAlign: TextAlign.left,
                    )),
                widget.userInfo.mainPhoto == null ? Container() : Icon(Icons.camera_alt, color: Colors.blueAccent, size: 20),
                widget.userInfo.isStar ? Icon(Icons.star, color: Colors.yellow, size: 18) : Container(),
              ],
            )),
      ),
    );
  }
}
