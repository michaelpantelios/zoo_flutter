import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/main.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/zoomaniacs/maniacs_item.dart';
import 'package:zoo_flutter/models/maniacs/points_maniac_record.dart';
import 'package:zoo_flutter/models/maniacs/level_maniac_record.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

class ZooManiacs extends StatefulWidget{
  ZooManiacs();

  ZooManiacsState createState() => ZooManiacsState();
}

class ZooManiacsState extends State<ZooManiacs>{
  ZooManiacsState();

  double _componentsDistance = 170;
  int _myZooPointsRank = 0;
  int _myZooLevelRank = 0;

  RPC _rpc;

  List<LevelManiacRecord> _levelManiacsList = [];

  @override
  void initState() {
    super.initState();
    // _rpc = RPC();

    // _getUserStats();

  }

  _getUserStats() async {
    var res = await _rpc.callMethod("OldApps.Stats.getUserStats");

    if (res["status"] == "ok") {
      print(res["data"]);
    } else {
      print("ERROR");
      print(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("ZooManiacs Build");
    return Container(
        width: Root.AppSize.width - GlobalSizes.panelWidth - 2 * GlobalSizes.fullAppMainPadding,
        height: Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding,
        child: Column(
          children: [
            Container(
                height: 30,
                color: Theme.of(context).secondaryHeaderColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 60),
                    // Text(AppLocalizations.of(context).translate("app_zoomaniacs_points_title"),
                    // style: TextStyle(color: Color(0xff151922), fontSize: 20, fontWeight: FontWeight.normal),
                    // textAlign: TextAlign.left),
                    // SizedBox(width: 30),
                    // Text(AppLocalizations.of(context).translateWithArgs("app_zoomaniacs_my_rank", [_myZooPointsRank.toString()]),
                    // style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
                    // textAlign: TextAlign.left),
                    // SizedBox(width: _componentsDistance),
                    // Text(AppLocalizations.of(context).translate("app_zoomaniacs_level_title"),
                    //     style: TextStyle(color: Color(0xff151922), fontSize: 20, fontWeight: FontWeight.normal),
                    //     textAlign: TextAlign.left),
                    // SizedBox(width: 30),
                    // Text(AppLocalizations.of(context).translateWithArgs("app_zoomaniacs_my_rank", [_myZooLevelRank.toString()]),
                    //     style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
                    //     textAlign: TextAlign.left),
                  ],
                )
            )
          ],
        )
    );
  }



}