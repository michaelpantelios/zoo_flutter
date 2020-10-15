//widget containing opened apps

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppsArea extends StatelessWidget {
  AppsArea();

  @override
  Widget build(BuildContext context) {
    return  Expanded(
        child: Container(
            color: Theme.of(context).backgroundColor
        )
    );
  }
}