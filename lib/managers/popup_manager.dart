import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';

class PopupManager {
  PopupManager._privateConstructor();

  static final PopupManager instance = PopupManager._privateConstructor();

  Future<dynamic> show({@required context, @required title, @required app, @required titleBarIcon, size, id, content, closeFunction, closeIcon, overlayColor = Colors.transparent, onWillPopActive = false, isOverlayTapDismiss = false}) async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        final Widget _child = ConstrainedBox(
          constraints: BoxConstraints.expand(width: double.infinity, height: double.infinity),
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: SimpleDialog(
                key: Key(id),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
                elevation: 10,
                contentPadding: EdgeInsets.zero,
                children: [
                  PopupContainerBar(
                    title: title,
                    iconData: titleBarIcon,
                    onCloseBtnHandler: () {
                      print("closed this popup!");
                      Navigator.of(context, rootNavigator: true).pop(1);
                    },
                  ),
                  SizedBox(
                    width: size.width,
                    height: size.height,
                    child: app,
                  )
                ],
              ),
            ),
          ),
        );
        return onWillPopActive ? WillPopScope(onWillPop: () async => false, child: _child) : _child;
      },
      barrierDismissible: isOverlayTapDismiss,
      barrierColor: overlayColor,
      useRootNavigator: true,
    );
  }
}
