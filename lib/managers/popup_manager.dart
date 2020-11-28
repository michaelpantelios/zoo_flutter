import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zoo_flutter/containers/popup/popup_container_bar.dart';

class PopupContainer {
  final String id;
  final BuildContext context;
  final String title;
  final Widget app;
  final Widget content;
  final Function closeFunction;
  final Icon closeIcon;
  final bool onWillPopActive;
  final bool isOverlayTapDismiss;
  final Color overlayColor;
  final IconData titleBarIcon;
  final Size size;

  PopupContainer({
    @required this.context,
    @required this.title,
    @required this.app,
    @required this.titleBarIcon,
    this.size,
    this.id,
    this.content,
    this.closeFunction,
    this.closeIcon,
    this.overlayColor = Colors.transparent,
    this.onWillPopActive = false,
    this.isOverlayTapDismiss = false,
  });

  Future<int> show() async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return _buildDialog();
      },
      barrierDismissible: isOverlayTapDismiss,
      barrierColor: overlayColor,
      useRootNavigator: true,
    );
  }

  Future<void> dismiss() async {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Widget _buildDialog() {
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
                  dismiss();
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
  }
}
