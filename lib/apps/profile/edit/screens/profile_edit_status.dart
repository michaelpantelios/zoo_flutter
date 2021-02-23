import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class ProfileEditStatus extends StatefulWidget {
  ProfileEditStatus({Key key, this.status, this.mySize, this.onClose});
  
  final String status;
  final Size mySize;
  final Function onClose;
  
  ProfileEditStatusState createState() => ProfileEditStatusState(key : key);
}

class ProfileEditStatusState extends State<ProfileEditStatus> {
  ProfileEditStatusState({Key key});

  TextEditingController _bodyTextController = TextEditingController();

  _onOKHandler(){
    var data = {};
    data["status"] = _bodyTextController.text;
    data["editType"] = "status";

    widget.onClose(data);
  }

  @override
  void initState() {
    _bodyTextController.text = widget.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: Color(0xff9598a4), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
            child: TextField(
              controller: _bodyTextController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              maxLines: 7,
            )
          ),
          Container(
            margin: EdgeInsets.only(top:20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ZButton(
                  minWidth: 120,
                  height: 40,
                  buttonColor: Colors.green,
                  clickHandler: _onOKHandler,
                  iconData: Icons.check,
                  iconColor: Colors.white,
                  iconSize: 30,
                  label: AppLocalizations.of(context).translate("ok"),
                  labelStyle: Theme.of(context).textTheme.button,
                ),
              ],
            )
          )
        ],
      )
    );
  }
  
  
  
}