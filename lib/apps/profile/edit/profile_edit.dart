import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/apps/profile/edit/screens/profile_edit_details.dart';
import 'package:zoo_flutter/apps/profile/edit/screens/profile_edit_status.dart';
import 'package:zoo_flutter/apps/profile/edit/profile_edit_button.dart';

class ProfileEdit extends StatefulWidget {
  ProfileEdit({this.profileInfo, this.size,  this.onClose});

  final Function onClose;
  final ProfileInfo profileInfo;
  final Size size;

  ProfileEditState createState() => ProfileEditState();
}

class ProfileEditState extends State<ProfileEdit> {
  ProfileEditState();
  Map<String, GlobalKey<ProfileEditButtonState>> _buttonKeys;

  GlobalKey<ProfileEditButtonState> _editProfileDetailsButtonKey;
  GlobalKey<ProfileEditButtonState> _editStatusButtonKey;

  String _selectedButtonId = "editDetails";
  int _selectedIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(updateSettingsButtons);
    _buttonKeys = new Map<String, GlobalKey<ProfileEditButtonState>>();

    _editProfileDetailsButtonKey = new GlobalKey<ProfileEditButtonState>();
    _editStatusButtonKey = new GlobalKey<ProfileEditButtonState>();

    _buttonKeys["editDetails"] = _editProfileDetailsButtonKey;
    _buttonKeys["editStatus"] = _editStatusButtonKey;

    super.initState();
  }

  updateSettingsButtons(_) {
    _buttonKeys.forEach((key, value) => value.currentState.setActive(key == _selectedButtonId));
  }

  onEditButtonTap(String id){
    print("tapped on :" + id);
    setState(() {
      _selectedButtonId = id;
      if (id == "editDetails"){
        _selectedIndex = 0;
      } else if (id == "editStatus") {
        _selectedIndex = 1;
      }

      updateSettingsButtons(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfileEditButton(
              key: _editProfileDetailsButtonKey,
              id: "editDetails",
              icon: "edit_details_icon",
              title: AppLocalizations.of(context).translate("app_profile_edit_details_title"),
              onTapHandler: onEditButtonTap
            ),
            ProfileEditButton(
              key: _editStatusButtonKey,
              id: "editStatus",
              icon : "edit_status_icon",
              title: AppLocalizations.of(context).translate("app_profile_edit_status"),
              onTapHandler: onEditButtonTap,
            )
          ],
        ),
        Container(
          width: widget.size.width - 180,
          child: Center(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                ProfileEditDetails(
                  mySize: new Size(widget.size.width - 180, widget.size.height - 10),
                  profileInfo: widget.profileInfo,
                  onClose: widget.onClose
                ),
                ProfileEditStatus(
                  mySize: new Size(widget.size.width - 180, widget.size.height - 10),
                  status: widget.profileInfo.status,
                  onClose: widget.onClose
                )
              ],
            )
          )
        )
      ],
    );
  }
}
