import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class FullAppContainerBarButton extends StatefulWidget {
  FullAppContainerBarButton({Key key, @required this.popupInfo})
      : assert(popupInfo != null),
        super(key: key);

  final PopupInfo popupInfo;

  @override
  FullAppContainerBarButtonState createState() => FullAppContainerBarButtonState();
}

class FullAppContainerBarButtonState extends State<FullAppContainerBarButton> {
  FullAppContainerBarButtonState({Key key});

  GlobalKey _key;
  bool isMenuOpen = false;
  Offset buttonPosition;
  Size buttonSize;
  OverlayEntry _overlayEntry;
  BorderRadius _borderRadius;

  List<Icon> icons = [
    Icon(Icons.person),
    Icon(Icons.settings),
    Icon(Icons.credit_card),
  ];

  @override
  void initState() {
    _borderRadius = BorderRadius.circular(4);
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry.remove();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: AppLocalizations.of(context).translate(widget.popupInfo.appName),
        textStyle: TextStyle(fontSize: 14),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue[900],
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            new BoxShadow(color: Color(0xaa000000), offset: new Offset(2.0, 2.0), blurRadius: 6, spreadRadius: 3),
          ],
        ),
        child: Container(
            key: _key,
            decoration: BoxDecoration(
              color: Color(0xffff7800),
              border: Border.all(
                color: Color(0xffff7800),
                width: 1.0,
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(
              onPressed: () {
                PopupManager.instance.show(context: context, popup: widget.popupInfo.id, callbackAction: (retValue) {});
              },
              icon: Icon(widget.popupInfo.iconPath, size: 25, color: Colors.white),
            )));
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return PointerInterceptor(
          child: Positioned(
            top: buttonPosition.dy + buttonSize.height,
            left: buttonPosition.dx,
            width: buttonSize.width,
            child: Material(
              color: Colors.transparent,
              child: PointerInterceptor(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        height: icons.length * buttonSize.height,
                        decoration: BoxDecoration(
                          color: Color(0xFFF67C0B9),
                          borderRadius: _borderRadius,
                        ),
                        child: Theme(
                          data: ThemeData(
                            iconTheme: IconThemeData(
                              color: Colors.white,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(icons.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  closeMenu();
                                },
                                child: Container(
                                  width: buttonSize.width,
                                  height: buttonSize.height,
                                  child: icons[index],
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
