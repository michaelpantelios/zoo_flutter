import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/widgets/online_counters.dart';

class PanelHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(5), child: Image.asset("assets/images/panelheader/zoo.png")),
          Padding(
            padding: EdgeInsets.all(5),
            child: OnlineCounters(),
          )
        ],
      ),
    );
  }
}
