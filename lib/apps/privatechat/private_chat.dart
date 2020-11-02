import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/control/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/apps/chat/chat_messages_list.dart';

class PrivateChat extends StatefulWidget{
  PrivateChat({Key key});

  PrivateChatState createState() => PrivateChatState();
}

class PrivateChatState extends State<PrivateChat>{
  PrivateChatState();

  Size _appSize = DataMocker.apps["privateChat"].size;
  final GlobalKey _key = GlobalKey();
  final GlobalKey _messagesListKey = GlobalKey<ChatMessagesListState>();
  Size userContainerSize = new Size(150,150);
  UserInfo testUser = DataMocker.users.where((element) => element.userId == 7).first;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    getSexString(int sex) {
      switch (sex) {
        case 0:
          return AppLocalizations.of(context).translate("user_sex_male");
        case 1:
          return AppLocalizations.of(context).translate("user_sex_female");
        case 2:
          return AppLocalizations.of(context).translate("user_sex_couple");
      }
    }

    return Stack(
      key: _key,
      children: [
        Container(
          color: Theme.of(context).canvasColor,
          // padding: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 5),
                      height: _appSize.height*0.75,

                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          )),
                      padding: EdgeInsets.all(3),
                      // color: Colors.black,
                      // child: ChatMessagesList(key : _messagesListKey)
                    )

                ],
              ),
              SizedBox(width:10),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    width: userContainerSize.width,
                    // height: userContainerSize.height,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[700],
                          width: 1,
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (testUser.photoUrl == "")
                          FaIcon(testUser.sex == 2 ? FontAwesomeIcons.userFriends : Icons.face, size: userContainerSize.height * 0.75, color: testUser.sex == 0 ? Colors.blue : testUser.sex == 1 ? Colors.pink : Colors.green)
                        else Image.network(testUser.photoUrl, height: userContainerSize.height * 0.75),
                        Padding(
                          padding:EdgeInsets.all(3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context).translate("userInfo_username"),
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.left,),
                              Text(testUser.username,
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left,)
                            ],
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.all(3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context).translate("userInfo_sex"),
                                style: Theme.of(context).textTheme.headline6,
                                textAlign: TextAlign.left,),
                              Text(getSexString(testUser.sex),
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left,)
                            ],
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.all(3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context).translate("userInfo_age"),
                                style: Theme.of(context).textTheme.headline6,
                                textAlign: TextAlign.left,),
                              Text(testUser.age.toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left,)
                            ],
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.all(3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context).translate("userInfo_country"),
                                style: Theme.of(context).textTheme.headline6,
                                textAlign: TextAlign.left,),
                              Text(testUser.country,
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left,)
                            ],
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.all(3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context).translate("userInfo_city"),
                                style: Theme.of(context).textTheme.headline6,
                                textAlign: TextAlign.left,),
                              Text(testUser.city,
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.left,)
                            ],
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.all(3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Tooltip(
                                message: AppLocalizations.of(context).translate("userInfo_tpFriends"),
                                child: IconButton(
                                    onPressed: (){},
                                    icon: FaIcon(FontAwesomeIcons.userPlus, size: 20, color: Colors.green)
                                ),
                              ),
                              Tooltip(
                                message: AppLocalizations.of(context).translate("userInfo_tpGift"),
                                child: IconButton(
                                    onPressed: (){},
                                    icon: FaIcon(FontAwesomeIcons.gift, size: 20, color: Colors.red)
                                ),
                              ),
                              Tooltip(
                                message: AppLocalizations.of(context).translate("userInfo_tpProfile"),
                                child: IconButton(
                                    onPressed: (){},
                                    icon: Icon(Icons.account_box, size: 20, color: Colors.orange)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          )
        )
      ],
    );
  }
}