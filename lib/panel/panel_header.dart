import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class PanelHeader extends StatefulWidget {
  PanelHeader();

  PanelHeaderState createState() => PanelHeaderState();
}

class PanelHeaderState extends State<PanelHeader>{
  PanelHeaderState();

  double width = 290;
  double height = 155;
  double _textFieldWidth = 150;

  bool _logged = false;
  bool _hasMainPhoto = false;

  openProfile(BuildContext context, int userId){
    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userId,  callbackAction: (retValue) {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userLogged = context.select((UserProvider p) => p.logged);
    print("========> userLogged ="+userLogged.toString());
    return !userLogged ? Container() : Container(
        width: GlobalSizes.panelWidth,
        child: Center(
            child: FlatButton(
              onPressed: (){
                openProfile(context, UserProvider.instance.userInfo.userId);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: GlobalSizes.panelWidth-20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  // border: Border.all(color: Colors.deepOrange, width: 3),
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    new BoxShadow(color: Theme.of(context).shadowColor, offset: new Offset(4.0, 4.0), blurRadius: 4, spreadRadius: 4),
                  ],
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: (UserProvider.instance.userInfo.mainPhoto != null && UserProvider.instance.userInfo.mainPhoto["image_id"]!=null) ?
                        Image.network(Utils.instance.getUserPhotoUrl(photoId: UserProvider.instance.userInfo.mainPhoto["image_id"].toString()),
                            height: 100,
                            width: 100,
                            fit: BoxFit.fitWidth) :
                        Container(
                          width: 100,
                          height: 100,
                          color: Theme.of(context).primaryColor,
                          child:  Image.asset(UserProvider.instance.userInfo.sex == 1 ?  "assets/images/general/male_user.png" : "assets/images/general/female_user.png",
                              height: 90,
                              width: 90,
                              fit: BoxFit.fitWidth),
                        ),
                      ),
                      Container(
                          width: _textFieldWidth,
                          margin: EdgeInsets.only(left:10),
                          child: Column(
                            children: [
                              
                            ],
                          )
                      )
                    ],
                  ),

                ),
              ),
            )
        )
    );
  }
  
}
