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

  ZooManiacsStyle createState() => ZooManiacsStyle();
}

class ZooManiacsStyle extends State<ZooManiacs>{
  ZooManiacsStyle();

  double _controlsHeight = 85;

  RPC _rpc;

  List<LevelManiacRecord> _levelManiacsList = [];

  @override
  void initState() {
    super.initState();
    _rpc = RPC();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }



}