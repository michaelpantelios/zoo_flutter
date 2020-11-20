import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/models/user/user_info_model.dart';

class UserBasicInfo extends StatelessWidget{
  UserBasicInfo({Key key, @required this.userInfo, @required this.size});

  final UserInfoModel userInfo;
  final Size size;

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

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(5),
      width: size.width,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[700],
            width: 1,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (userInfo.photoUrl == "" || userInfo.photoUrl == null)
            FaIcon(userInfo.sex == 2 ? FontAwesomeIcons.userFriends : Icons.face, size: size.height * 0.75, color: userInfo.sex == 0 ? Colors.blue : userInfo.sex == 1 ? Colors.pink : Colors.green)
          else Image.network(userInfo.photoUrl, height: size.height * 0.75),
          Padding(
            padding:EdgeInsets.all(3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).translate("userInfo_username"),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.left,),
                Text(userInfo.username,
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
                Text(getSexString(userInfo.sex),
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
                Text(userInfo.age.toString(),
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
                Text(userInfo.country,
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
                Text(userInfo.city,
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
    );
  }
}