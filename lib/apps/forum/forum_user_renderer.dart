import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/forum/models/forum_user_model.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';

class ForumUserRenderer extends StatelessWidget {
  ForumUserRenderer({Key key, @required this.userInfo});

  final ForumUserModel userInfo;

  _openProfile(BuildContext context, int userId){
    print("_openProfile " + userId.toString());
    if (!UserProvider.instance.logged) {
      PopupManager.instance.show(
          context: context,
          popup: PopupType.Login,
          callbackAction: (res) {
            if (res) {
              print("ok");
              _doOpenProfile(context, userId);
            }
          });
      return;
    }
    _doOpenProfile(context, userId);
  }

  _doOpenProfile(BuildContext context, int userId){
    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userId,  callbackAction: (retValue) {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _openProfile(context, userInfo.userId);
        },
        child: Container(
            padding: EdgeInsets.only(top: 3, bottom: 3, right: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                int.parse(userInfo.sex.toString()) == 1 ? Image.asset("assets/images/user_renderers/male.png") : Image.asset("assets/images/user_renderers/female.png"),
                Flexible(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: Text(
                          userInfo.username,
                          style: TextStyle(
                              fontSize: 12.0, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis
                      )
                  ),
                ),
                userInfo.mainPhoto == null ? Container() : Icon(Icons.camera_alt, color: Theme.of(context).primaryColor, size: 20)
              ],
            )),
      );
  }
}
