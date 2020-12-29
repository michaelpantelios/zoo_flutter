import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/apps/home/modules/module_header.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';

class HomeModuleProfileView extends StatefulWidget {
  HomeModuleProfileView();

  HomeModuleProfileViewState createState() => HomeModuleProfileViewState();
}

class HomeModuleProfileViewState extends State<HomeModuleProfileView>{
  HomeModuleProfileViewState();

  RPC _rpc;

  _doOpenProfile(BuildContext context, int userId){
    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userId,  callbackAction: (retValue) {});
  }

  List<String> _dates = new List<String>();


  @override
  void initState() {
    _rpc = RPC();
    
    super.initState();
  }

  getProfileViewsForDate(String date) async {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        // border: Border.all(color: Colors.deepOrange, width: 3),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getModuleHeader(AppLocalizations.of(context).translate("app_home_module_title_who_sees_me")),
          Padding(
            padding: EdgeInsets.all(7),
            child: Column(
              children: [

              ],
            )
          )
        ],
      )
    );
  }


  
}