import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';

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
    return Container(
        key: _key,
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          border: Border.all(
            color: Theme.of(context).secondaryHeaderColor,
            width: 1.0,
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: IconButton(
          onPressed: () {
            PopupManager.instance.show(context: context, popup: widget.popupInfo.id, callbackAction: (retValue) {});
          },
          icon: Icon(widget.popupInfo.iconPath, size: 25, color: Colors.white),
        ));
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          width: buttonSize.width,
          child: Material(
            color: Colors.transparent,
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
        );
      },
    );
  }
}
