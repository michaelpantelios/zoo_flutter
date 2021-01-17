import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/main.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/zoomaniacs/points_maniacs_item.dart';
import 'package:zoo_flutter/models/maniacs/points_maniac_record.dart';
import 'package:zoo_flutter/models/maniacs/level_maniac_record.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

class ZooManiacs extends StatefulWidget{
  ZooManiacs({this.size});

  final Size size;

  ZooManiacsState createState() => ZooManiacsState();
}

class ZooManiacsState extends State<ZooManiacs>{
  ZooManiacsState();

  double _componentsDistance = 30;
  int _myZooPointsRank = 0;
  int _myZooLevelRank = 0;


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    print("ZooManiacs Build");
    return Container(
        width: widget.size.width,
        height: widget.size.height,
        child: Row(
          children: [
            Container(
                height: 30,
                color: Theme.of(context).secondaryHeaderColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10),
                    Text(AppLocalizations.of(context).translate("app_zoomaniacs_points_title"),
                    style: TextStyle(color: Color(0xff151922), fontSize: 20, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.left),
                    SizedBox(width: _componentsDistance),
                    Text(AppLocalizations.of(context).translateWithArgs("app_zoomaniacs_my_rank", [_myZooPointsRank.toString()]),
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.left),
                    SizedBox(width: _componentsDistance),
                    Text(AppLocalizations.of(context).translate("app_zoomaniacs_level_title"),
                        style: TextStyle(color: Color(0xff151922), fontSize: 20, fontWeight: FontWeight.normal),
                        textAlign: TextAlign.left),
                    SizedBox(width: _componentsDistance),
                    Text(AppLocalizations.of(context).translateWithArgs("app_zoomaniacs_my_rank", [_myZooLevelRank.toString()]),
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
                        textAlign: TextAlign.left),
                    SizedBox(width: 10),
                  ],
                )
            )
          ],
        )
    );
  }



}