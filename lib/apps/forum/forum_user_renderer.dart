import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/forum/models/forum_user_model.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';

class ForumUserRenderer extends StatelessWidget {
  ForumUserRenderer({Key key, @required this.userInfo});

  final ForumUserModel userInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // print("paparia mantoles");
         PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userInfo.userId,  callbackAction: (retValue) {});
        },
        child: Container(
            padding: EdgeInsets.only(top: 3, bottom: 3, right: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.face, color: userInfo.sex == 0 ? Colors.blue : Colors.pink, size: 30),
                Padding(padding: EdgeInsets.symmetric(horizontal: 3), child: Text(userInfo.username, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left)),
                userInfo.mainPhoto == null ? Container() : Icon(Icons.camera_alt, color: Colors.orange, size: 20)
              ],
            )),
      )
    ;
  }
}
