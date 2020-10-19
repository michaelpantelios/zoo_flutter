import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsTooltip extends StatelessWidget {
  SettingsTooltip();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(5),
            child: Text("option 1", style: Theme.of(context).textTheme.bodyText1)
        ),
        Padding(
            padding: EdgeInsets.all(5),
            child: Text("option 2", style: Theme.of(context).textTheme.bodyText1)
        ),
        Padding(
            padding: EdgeInsets.all(5),
            child: Text("option 1", style: Theme.of(context).textTheme.bodyText1)
        )
      ],
    );
  }
}