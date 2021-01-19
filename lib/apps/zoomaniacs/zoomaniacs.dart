import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/zoomaniacs/points_maniacs.dart';
import 'package:zoo_flutter/main.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/zoomaniacs/points_maniacs_item.dart';
import 'package:zoo_flutter/models/maniacs/points_maniac_record.dart';
import 'package:zoo_flutter/models/maniacs/level_maniac_record.dart';
import 'package:zoo_flutter/apps/zoomaniacs/maniacs_button.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

class ZooManiacs extends StatefulWidget{
  ZooManiacs({this.size});

  final Size size;

  ZooManiacsState createState() => ZooManiacsState();
}

class ZooManiacsState extends State<ZooManiacs>{
  ZooManiacsState();

  double _myHeight;
  Map<String, GlobalKey<ManiacsButtonState>> maniacsButtonKeys;

  double _topSpace = 30;
  double _componentsDistance = 30;
  int _myZooPointsRank = 0;
  int _myZooLevelRank = 0;

  int _selectedIndex = 0;

  GlobalKey<ManiacsButtonState> pointsManiacsKey;
  GlobalKey<ManiacsButtonState> levelManiacsKey;

  String selectedButtonId = "zooPoints";

  onManiacsButtonTap(String id) {
    print("tapped on :" + id);
    setState(() {
      selectedButtonId = id;
      if (id == "zooPoints") {
        _selectedIndex = 0;
      } else if (id == "zooLevel") {
        _selectedIndex = 1;
      }

      updateManiacsButtons(null);
    });
  }

  updateManiacsButtons(_) {
    maniacsButtonKeys.forEach((key, value) => value.currentState.setActive(key == selectedButtonId));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(updateManiacsButtons);
    super.initState();

    _myHeight = Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding;

    maniacsButtonKeys = new Map<String, GlobalKey<ManiacsButtonState>>();

    pointsManiacsKey = new GlobalKey<ManiacsButtonState>();
    levelManiacsKey = new GlobalKey<ManiacsButtonState>();

    maniacsButtonKeys["zooPoints"] = pointsManiacsKey;
    maniacsButtonKeys["zooLevel"] = levelManiacsKey;

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.size.width,
        height: _myHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 220,
                  height: _myHeight - _topSpace,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ManiacsButton(
                        key: pointsManiacsKey,
                        id: "zooPoints",
                        title: AppLocalizations.of(context).translate("app_zoomaniacs_zoo_points"),
                        onTapHandler: onManiacsButtonTap,
                      ),
                      ManiacsButton(
                        key: levelManiacsKey,
                        id: "zooLevel",
                        title: AppLocalizations.of(context).translate("app_zoomaniacs_zoo_level"),
                        onTapHandler: onManiacsButtonTap,
                      )
                    ],
                  )
                ),
                SizedBox(width:5),
                SizedBox(
                  width: 700,
                  height: _myHeight - _topSpace,
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      PointsManiacs(myHeight: _myHeight - _topSpace)
                    ],
                  )
                )
              ],
            )
          ],
        )
        // Row(
        //   children: [
        //     Container(
        //         height: 30,
        //         color: Theme.of(context).secondaryHeaderColor,
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             SizedBox(width: 10),
        //             Text(AppLocalizations.of(context).translate("app_zoomaniacs_points_title"),
        //             style: TextStyle(color: Color(0xff151922), fontSize: 20, fontWeight: FontWeight.normal),
        //             textAlign: TextAlign.left),
        //             SizedBox(width: _componentsDistance),
        //             Text(AppLocalizations.of(context).translateWithArgs("app_zoomaniacs_my_rank", [_myZooPointsRank.toString()]),
        //             style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
        //             textAlign: TextAlign.left),
        //             SizedBox(width: _componentsDistance),
        //             Text(AppLocalizations.of(context).translate("app_zoomaniacs_level_title"),
        //                 style: TextStyle(color: Color(0xff151922), fontSize: 20, fontWeight: FontWeight.normal),
        //                 textAlign: TextAlign.left),
        //             SizedBox(width: _componentsDistance),
        //             Text(AppLocalizations.of(context).translateWithArgs("app_zoomaniacs_my_rank", [_myZooLevelRank.toString()]),
        //                 style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
        //                 textAlign: TextAlign.left),
        //             SizedBox(width: 10),
        //           ],
        //         )
        //     )
        //   ],
        // )
    );
  }



}