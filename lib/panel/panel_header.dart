import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/utils/utils.dart';

class PanelHeader extends StatefulWidget {
  PanelHeader();

  PanelHeaderState createState() => PanelHeaderState();
}

class PanelHeaderState extends State<PanelHeader> {
  PanelHeaderState();

  // double width = 225;
  double height = 110;
  double _textFieldWidth = 120;

  bool _logged = false;
  bool _hasMainPhoto = false;

  openProfile(BuildContext context, int userId) {
    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userId, callbackAction: (retValue) {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userLogged = context.select((UserProvider p) => p.logged);
    return !userLogged
        ? Container()
        : Container(
            width: GlobalSizes.panelWidth,
            height: height,
            margin: EdgeInsets.only(bottom: GlobalSizes.fullAppMainPadding),
            child: Center(
                child: FlatButton(
                  padding: EdgeInsets.all(0),
              onPressed: () {
                openProfile(context, UserProvider.instance.userInfo.userId);
              },
              child: Container(
                width: GlobalSizes.panelWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  // border: Border.all(color: Colors.deepOrange, width: 3),
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    new BoxShadow(color: Color(0x15000000), offset: new Offset(4.0, 4.0), blurRadius: 5, spreadRadius: 2),
                  ],
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: (UserProvider.instance.userInfo.mainPhoto != null && UserProvider.instance.userInfo.mainPhoto["image_id"] != null)
                            ? Image.network(Utils.instance.getUserPhotoUrl(photoId: UserProvider.instance.userInfo.mainPhoto["image_id"].toString(), size: "normal"), height: 60, width: 60, fit: BoxFit.fitWidth)
                            : Container(
                                width: 60,
                                height: 60,
                                color: Theme.of(context).primaryColor,
                                child: Image.asset(UserProvider.instance.userInfo.sex == 1 ? "assets/images/general/male_user.png" : "assets/images/general/female_user.png", height: 40, width: 40, fit: BoxFit.contain),
                              ),
                      ),
                      Container(
                          width: _textFieldWidth,
                          height: 80,
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(UserProvider.instance.userInfo.username, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, maxLines: 1),
                              Text(AppLocalizations.of(context).translate("panelheader_welcome_label"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.normal)),
                              Expanded(child: Container()),
                              Text(AppLocalizations.of(context).translate("panelheader_profile_edit"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13, fontWeight: FontWeight.normal)),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            )));
  }
}
