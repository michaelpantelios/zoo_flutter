import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class UserBasicInfo extends StatelessWidget {
  UserBasicInfo({Key key, @required this.profileInfo, @required this.size});

  final ProfileInfo profileInfo;
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
        children: profileInfo != null
            ? [
                if (profileInfo.user.mainPhoto == null || profileInfo.user.mainPhoto == null)
                  FaIcon(profileInfo.user.sex == 2 ? FontAwesomeIcons.userFriends : Icons.face,
                      size: size.height * 0.75,
                      color: profileInfo.user.sex == 0
                          ? Colors.blue
                          : profileInfo.user.sex == 1
                              ? Colors.pink
                              : Colors.green)
                else
                  Image.network(profileInfo.user.mainPhoto.imageId, height: size.height * 0.75),
                Padding(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("userInfo_username"),
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        profileInfo.user.username,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("userInfo_sex"),
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        getSexString(profileInfo.user.sex),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("userInfo_age"),
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        profileInfo.age.toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("userInfo_country"),
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        profileInfo.country.toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("userInfo_city"),
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        profileInfo.city,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Tooltip(
                        message: AppLocalizations.of(context).translate("userInfo_tpFriends"),
                        child: IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.userPlus, size: 20, color: Colors.green)),
                      ),
                      Tooltip(
                        message: AppLocalizations.of(context).translate("userInfo_tpGift"),
                        child: IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.gift, size: 20, color: Colors.red)),
                      ),
                      Tooltip(
                        message: AppLocalizations.of(context).translate("userInfo_tpProfile"),
                        child: IconButton(onPressed: () {}, icon: Icon(Icons.account_box, size: 20, color: Colors.orange)),
                      ),
                    ],
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}
