import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/taskmanager/task_manager_settings_dropdown_item.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/utils/utils.dart';


class TaskManagerSettingsButton extends StatefulWidget {
  TaskManagerSettingsButton();

  TaskManagerSettingsButtonState createState() => TaskManagerSettingsButtonState();
}

class TaskManagerSettingsButtonState extends State<TaskManagerSettingsButton>{
  TaskManagerSettingsButtonState();

  GlobalKey _key;
  bool isMenuOpen = false;
  Offset buttonPosition;
  Size buttonSize;
  OverlayEntry _overlayEntry;
  Size _overlaySize = new Size(250, 235);
  double _buttonWidth = 65;

  _onStatsItemTap(){
    AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("unavailable_service"));
  }

  _onAccountSettingsItemTap(){
    PopupManager.instance.show(context: context, popup: PopupType.Settings);
  }

  _onSupportItemTap() async {
      if (await canLaunch(Utils.instance.getHelpUrl())) {
        await launch(Utils.instance.getHelpUrl());
      } else {
        throw 'Could not launch $Utils.instance.getHelpUrl()';
      }
  }

  _onFriendsManageItemTap(){
    PopupManager.instance.show(context: context, popup: PopupType.Friends);
  }

  _onLogoutItemTap(){
    UserProvider.instance.logout();
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
    if (isMenuOpen) {closeMenu(); return; }
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx - _overlaySize.width + _buttonWidth,
          width: _overlaySize.width,
          child: Material(
            color: Colors.transparent,
            child: MouseRegion(
              onExit: (e) => closeMenu(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  // border: Border.all(color: Colors.deepOrange, width: 3),
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    new BoxShadow(color: Theme.of(context).shadowColor, offset: new Offset(-3.0, 4.0), blurRadius: 3, spreadRadius: 3),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TaskmanagerSettingsDropdownItem(
                        text: AppLocalizations.of(context).translate("taskmanager_settings_item_stats"),
                        iconData: Icons.bar_chart,
                        onTapHandler: (){
                          _onStatsItemTap();
                        }
                    ),
                    TaskmanagerSettingsDropdownItem(
                        text: AppLocalizations.of(context).translate("taskmanager_settings_item_settings"),
                        iconData: Icons.settings_applications_outlined,
                        onTapHandler: (){
                          _onAccountSettingsItemTap();
                        }
                    ),
                    TaskmanagerSettingsDropdownItem(
                        text: AppLocalizations.of(context).translate("taskmanager_settings_item_support_center"),
                        iconData: Icons.contact_support,
                        onTapHandler: (){
                          _onSupportItemTap();
                        }
                    ),
                    TaskmanagerSettingsDropdownItem(
                        text: AppLocalizations.of(context).translate("taskmanager_settings_item_friends_manage"),
                        iconData: Icons.people,
                        onTapHandler: (){
                          _onFriendsManageItemTap();
                        }
                    ),
                    TaskmanagerSettingsDropdownItem(
                        text: AppLocalizations.of(context).translate("taskmanager_settings_item_friends_logout"),
                        iconData: Icons.logout,
                        onTapHandler: (){
                          _onLogoutItemTap();
                        }
                    )
                  ],
                )
              )
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  ZButton(
      key: _key,
      minWidth: _buttonWidth,
      height: 40,
      buttonColor: Colors.white,
      iconData : Icons.settings,
      iconColor: Theme.of(context).primaryColor,
      iconSize: 30,
      clickHandler: (){
        openMenu();
      },
    );
  }


}
