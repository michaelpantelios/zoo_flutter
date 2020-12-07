import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

class MessengerChat extends StatefulWidget {
  MessengerChat({Key key});

  MessengerChatState createState() => MessengerChatState();
}

class MessengerChatState extends State<MessengerChat> {
  MessengerChatState();

  final GlobalKey _key = GlobalKey();
  Size userContainerSize = new Size(150, 150);
  UserInfo testUser = DataMocker.users.where((element) => element.userId == 6).first;
  UserInfo meUser = UserProvider.instance.userInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _key,
      children: [
        Container(
            color: Theme.of(context).canvasColor,
            // padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      width: userContainerSize.width,
                      height: userContainerSize.height,
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.grey[700],
                        width: 1,
                      )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(testUser.username, style: Theme.of(context).textTheme.headline6),
                          if (testUser.mainPhoto == "")
                            FaIcon(testUser.sex == 2 ? FontAwesomeIcons.userFriends : Icons.face,
                                size: userContainerSize.height * 0.75,
                                color: testUser.sex == 0
                                    ? Colors.blue
                                    : testUser.sex == 1
                                        ? Colors.pink
                                        : Colors.green)
                          else
                            Image.network(testUser.mainPhoto, height: userContainerSize.height * 0.75)
                        ],
                      ),
                    )
                  ],
                )
              ],
            ))
      ],
    );
  }
}
