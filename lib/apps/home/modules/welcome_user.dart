import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/home/modules/module_header.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

class HomeModuleWelcomeUser extends StatefulWidget {
  HomeModuleWelcomeUser();


  HomeModuleWelcomeUserState createState() => HomeModuleWelcomeUserState();
}

class HomeModuleWelcomeUserState extends State<HomeModuleWelcomeUser>{
  HomeModuleWelcomeUserState();

  getCoinsInfo(BuildContext context){
    if (context.select((UserProvider user) => user.userInfo.coins == 0))
        return Container(
          child: Column(
            children: [
              Text(AppLocalizations.of(context).translate("app_home_module_welcome_user_no_coins"),
               style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.normal)),
              GestureDetector(
                  onTap: (){ print("lets buy some coins"); },
                  child: Text(AppLocalizations.of(context).translate("app_home_module_welcome_user_more_coins"),
                      style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold))
              )
            ],
          )
        );
     else
      return Container(
        child: Column(
          children: [
            Html(
                data:
                AppLocalizations.of(context).translateWithArgs("app_home_module_welcome_user_coins", [UserProvider.instance.userInfo.coins.toString()]),
                style: {
                  "html": Style(
                      backgroundColor: Colors.white,
                      color: Colors.black,
                      textAlign: TextAlign.center,
                      fontSize: FontSize.medium),
                }),
           GestureDetector(
             onTap: (){ print("lets buy more coins"); },
             child: Text(AppLocalizations.of(context).translate("app_home_module_welcome_user_more_coins"),
             style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold))
           )
          ],
        )
      );
  }

  getStarInfo(){
    if (context.select((UserProvider user) => user.userInfo.star == 0))
      return Container(
        child: Column(
          children: [
            Text(AppLocalizations.of(context).translate("app_home_module_welcome_no_star"),
                style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.normal)),
            GestureDetector(
                onTap: (){ print("lets become star"); },
                child: Text(AppLocalizations.of(context).translate("app_home_module_welcome_become_star"),
                    style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold))
            )
          ],
        )
      );
      else return Container(
        child: Column(
          children: [
            Html(
                data:
                AppLocalizations.of(context).translateWithArgs("app_home_module_welcome_star", ["DATE"]),
                style: {
                  "html": Style(
                      backgroundColor: Colors.white,
                      color: Colors.black,
                      textAlign: TextAlign.center,
                      fontSize: FontSize.medium),
                }),
            GestureDetector(
                onTap: (){ print("lets extend star"); },
                child: Text(AppLocalizations.of(context).translate("app_home_module_welcome_extend_star"),
                    style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold))
            )
          ],
        )
    );
  }

  @override
  void initState() {
   super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        // border: Border.all(color: Colors.deepOrange, width: 3),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getModuleHeader(AppLocalizations.of(context).translateWithArgs("app_home_module_title_welcome_user", [UserProvider.instance.userInfo.username])),
          Padding(
            padding: EdgeInsets.all(5),
            child: getCoinsInfo(context)
          )
        ],
      )
    );
  }


}
