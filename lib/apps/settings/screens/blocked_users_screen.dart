import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/simple_user_renderer.dart';

class BlockedUsersScreen extends StatefulWidget {
  BlockedUsersScreen({Key key, this.mySize, this.setBusy});

  final Size mySize;
  final Function(bool value) setBusy;

  BlockedUsersScreenState createState() => BlockedUsersScreenState(key: key);
}

class BlockedUsersScreenState extends State<BlockedUsersScreen> {
  BlockedUsersScreenState({Key key});

  RPC _rpc;
  List<dynamic> _blockedUsers = [];

  @override
  void initState() {
    _rpc = RPC();

    super.initState();

    _loadBlocked();
  }

  _loadBlocked() async {
    print("Loading blocked");
    var res = await _rpc.callMethod("Messenger.Client.getBlockedUsers");
    print(res);
    setState(() {
      if (res["status"] == "ok") {
        _blockedUsers = res["data"];
      } else {
        _blockedUsers = [];
      }
    });
  }

  _unblockUser(UserInfo user) async {
    var userId = int.parse(user.userId.toString());
    var username = user.username.toString();
    AlertManager.instance.showSimpleAlert(
      context: context,
      bodyText: AppLocalizations.of(context).translateWithArgs("msgUnblockWarning", [username]),
      callbackAction: (retValue) async {
        if (retValue == 1) {
          var res = await _rpc.callMethod("Messenger.Client.removeBlocked", [userId]);
          if (res["status"] == "ok") {
            _loadBlocked();
          } else {
            AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate(res["errorMsg"]));
          }
        }
      },
      dialogButtonChoice: AlertChoices.OK_CANCEL,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      width: widget.mySize.width,
      height: widget.mySize.height - 5,
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).translate("lblBlocked"),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Divider(),
          Text(
            AppLocalizations.of(context).translate("txtBlockedUsersInfo"),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          ),
          Container(
            width: 450,
            height: 295,
            decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey, width: 1)),
            child: Scrollbar(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _blockedUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    UserInfo user = UserInfo.fromJSON(_blockedUsers[index]);
                    return Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
                      child: Row(
                        children: [
                          SimpleUserRenderer(
                            userInfo: user,
                            selected: false,
                            onSelected: (username) {},
                            onOpenProfile: (userId) {
                              PopupManager.instance.show(context: context, popup: PopupType.Profile, options: int.parse(userId.toString()), callbackAction: (retValue) {});
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              _unblockUser(user);
                            },
                            child: Image.asset("assets/images/friends/forbidden.png"),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
