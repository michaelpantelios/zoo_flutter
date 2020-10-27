import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/chat/chat_user_dropdown_item.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class ChatUserRenderer extends StatefulWidget {
  ChatUserRenderer({Key key, @required this.userInfo}) : assert(userInfo != null), super(key: key);

  final UserInfo userInfo;

  ChatUserRendererState createState() => ChatUserRendererState();
}

class ChatUserRendererState extends State<ChatUserRenderer>{
  ChatUserRendererState({Key key});

  bool isMenuOpen = false;
  Offset rendererPosition;
  Size rendererSize;
  OverlayEntry _overlayMenu;
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

  void closeMenu(){
    _overlayMenu.remove();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu(){
    findPosition();
    _overlayMenu = _overlayMenuBuilder();
    Overlay.of(context).insert(_overlayMenu);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if (isMenuOpen)
          closeMenu();
        else openMenu();
      },
      child: Container(
          padding: EdgeInsets.only(top: 3, bottom: 3, right: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon( Icons.face, color: widget.userInfo.sex == UserSex.Boy ? Colors.blue : Colors.pink, size: 30),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: Text(widget.userInfo.username, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left)
              ),
              widget.userInfo.photoUrl == null ? Container() : Icon(Icons.camera_alt, color: Colors.orange, size: 20)
            ],
          )
      ),
    );
  }

  onPrivateChatHandler(){
    print("private chat with "+widget.userInfo.username);
    closeMenu();
  }

  onShowUserPhotoHandler(){
    print("show photos of "+widget.userInfo.username);
    closeMenu();
  }

  onGameInvitationHandler(){
    print("invite "+widget.userInfo.username + " for a game");
    closeMenu();
  }

  onSendGiftHandler(){
    print("send gift to "+widget.userInfo.username);
    closeMenu();
  }

  onSendMailHandler(){
    print("send mail to "+widget.userInfo.username);
    closeMenu();
  }

  onShowUserProfileHandler() {
    print("show profile of "+widget.userInfo.username);
    closeMenu();
  }

  onIgnoreHandler() {
    print("ignore"+widget.userInfo.username);
    closeMenu();
  }

  OverlayEntry _overlayMenuBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: rendererPosition.dy + rendererSize.height,
          left: rendererPosition.dx + 10,
          width: 200,
          child: Material(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey[800],
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_0"), iconData: Icons.chat_bubble, onTapHandler: onPrivateChatHandler),
                    ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_1"), iconData: Icons.photo, onTapHandler: onShowUserPhotoHandler),
                    ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_2"), iconData: Icons.casino, onTapHandler: onGameInvitationHandler),
                    ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_3"), iconData: Icons.card_giftcard, onTapHandler: onSendGiftHandler),
                    ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_4"), iconData: Icons.outgoing_mail, onTapHandler: onSendMailHandler),
                    ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_5"), iconData: Icons.account_box, onTapHandler: onShowUserProfileHandler),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: Divider(
                        color: Colors.grey[300],
                        height: 2,
                        thickness: 2,
                      )
                    ),
                    ChatUserDropdownItem(text: AppLocalizations.of(context).translate("app_chat_user_renderer_menu_item_6"), iconData: Icons.not_interested, onTapHandler: onIgnoreHandler)
                   ],
                )
            )

          )
        );
      }
    );
  }
}