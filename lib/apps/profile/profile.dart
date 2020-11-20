import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/models/user/user_info_model.dart';
import 'package:zoo_flutter/control/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/utils/Utils.dart';

class Profile extends StatefulWidget {
  Profile();

  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile>{
  ProfileState();

  Size _appSize = DataMocker.apps["profile"].size;
  bool isMe = true;
  UserInfoModel user = User.instance.userInfo;
  double photoSize = 100;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    basicAreaRecord(String label, String data){
      return Container(
        padding: EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ),
              textAlign: TextAlign.left,
            ),
            Text(data, style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.left, softWrap: true, )
          ],
        )
      );
    }

    basicArea(){
      return Container(
        // padding: EdgeInsets.all(5),
        width:_appSize.width - 10,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.orangeAccent[50],
          border: Border.all(color: Colors.yellow[700], width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: photoSize+10,
              padding: EdgeInsets.all( 5 ),
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.yellow[700], width: 1)),
              ),
              child: Center(child: Container(
                  child:  (user.photoUrl == "" || user.photoUrl == null) ?
                  FaIcon(user.sex == 2 ? FontAwesomeIcons.userFriends : Icons.face, size: photoSize, color: user.sex == 0 ? Colors.blue : user.sex == 1 ? Colors.pink : Colors.green) :
                  Image.network(user.photoUrl, width: photoSize, height: photoSize)
              ) )
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.all( 5 ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.username, style: Theme.of(context).textTheme.headline2),
                      SizedBox(height: 3),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblQuote"), user.quote),
                              basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblGender"), Utils.instance.getSexString(context, user.sex)),
                              basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblAge"), user.age.toString()),
                              basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblZodiac"), user.zodiac),
                              basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblArea"), user.city+", "+user.country)
                            ],
                          ),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblSignup"), user.signupDate),
                              basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblLastLogin"), user.lastLogin),
                              basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblOnlineTime"), user.onlineTime)
                            ],
                          )
                        ],
                      )
                    ],
                  )
              )
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.yellow[700], width: 1)),
                ),
                padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Zoo Level", style: TextStyle(color: Colors.indigoAccent, fontSize: 20, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                    SizedBox(height: 5),
                    Text(user.zooLevel.toString(), style: TextStyle(color: Colors.red, fontSize: 25, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                    SizedBox(height: 5),
                    Icon(Icons.star, size: 55, color: user.star ? Colors.orange[300] : Colors.white)
                  ],
                )
            ),
          ],
        ),
      );
    }

    actionsArea(){
      return  (isMe) ? Container(
        width: 100,
        color: Colors.orange[300],
        padding : EdgeInsets.all(5),
        child: Text(
          AppLocalizations.of(context).translate("app_profile_app_profile_editBasicInfo"),
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
      )) : Container();
    }

    return Container(
          color: Theme.of(context).canvasColor,
          height:_appSize.height-4,
          width: _appSize.width,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(5.0),
            children: <Widget>[
              basicArea(),
              actionsArea()
            ],
          ),
    );
  }
}



