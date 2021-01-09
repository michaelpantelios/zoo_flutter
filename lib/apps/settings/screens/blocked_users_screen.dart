import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              AppLocalizations.of(context).translate("lblBlocked"),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xff393e54),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              AppLocalizations.of(context).translate("txtBlockedUsersInfo"),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xff393e54),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 10),
            width: 450,
            height: widget.mySize.height - 110,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xff9598a4),
                width: 2,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
            ),
            child: Scrollbar(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _blockedUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    UserInfo user = UserInfo.fromJSON(_blockedUsers[index]);
                    return Padding(
                      padding: const EdgeInsets.only(left: 5, right: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(0xffdc5b42),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/friends/ban_icon.png",
                                    height: 15,
                                    width: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
