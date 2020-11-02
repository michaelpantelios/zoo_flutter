import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/user/user_info.dart';

class ForumUserRenderer extends StatelessWidget {
  ForumUserRenderer({Key key, @required this.userInfo});

  final UserInfo userInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print("open user "+userInfo.userId.toString()+" profile");
      },
      child: Container(
          padding: EdgeInsets.only(top: 3, bottom: 3, right: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon( Icons.face, color: userInfo.sex == 0 ? Colors.blue : Colors.pink, size: 30),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: Text(userInfo.username, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left)
              ),
              userInfo.photoUrl == null ? Container() : Icon(Icons.camera_alt, color: Colors.orange, size: 20)
            ],
          )
      ),
    );
  }
}