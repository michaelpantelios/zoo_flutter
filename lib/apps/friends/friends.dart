import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/apps/friends/friend_request_renderer.dart';
import 'package:zoo_flutter/apps/friends/friend_result_item.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/friends/friend_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class Friends extends StatefulWidget {
  Friends({@required this.size, this.setBusy, this.onClose});

  final Size size;
  final Function(bool value) setBusy;
  final Function onClose;

  FriendsState createState() => FriendsState();
}

class FriendsState extends State<Friends> {
  FriendsState();

  RPC _rpc;

  int _servicePageIndex = 1;
  int _serviceRecsPerPageFactor = 10;

  double _resultsWidth;
  double _resultsHeight;
  int _resultRows;
  int _resultCols;
  int _itemsPerPage;

  int _totalPages = 0;
  int _currentPageIndex = 1;
  int _totalResultsNum;
  List<FriendInfo> _itemsFetched;
  List<UserInfo> _friendsRequests = [];

  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  List<Row> _rows = new List<Row>();
  List<GlobalKey<FriendResultItemState>> _itemKeysList = new List<GlobalKey<FriendResultItemState>>();

  FocusNode _searchUsernameFocusNode = FocusNode();
  TextEditingController _searchUsernameController = TextEditingController();

  ScrollController _friendsRequestsScrollController;

  @override
  void initState() {
    _friendsRequestsScrollController = ScrollController();
    _rpc = RPC();
    _itemsFetched = new List<FriendInfo>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchUsernameController.dispose();
  }

  @override
  void didChangeDependencies() {
    _resultsWidth = 560;
    _resultsHeight = 520;
    _resultRows = (_resultsHeight / FriendResultItem.myHeight).floor();
    _resultCols = (_resultsWidth / FriendResultItem.myWidth).floor();
    _itemsPerPage = _resultRows * _resultCols;
    print("_itemsPerPage = " + _itemsPerPage.toString());
    print("rows = " + _resultRows.toString());
    print("cols = " + _resultCols.toString());

    _createRows();

    super.didChangeDependencies();

    _getFriends();

    _fetchFriendsRequests();
  }

  _searchByUsername() {
    print("search by username: ${_searchUsernameController.text}");
    _getFriends(filter: {"username": _searchUsernameController.text, "online": null});
    _searchUsernameFocusNode.requestFocus();
  }

  _fetchFriendsRequests() async {
    var res = await _rpc.callMethod("Messenger.Client.getFriendshipRequests", []);
    List<UserInfo> lst = [];
    if (res["status"] == "ok") {
      for (var i = 0; i < res["data"]["records"].length; i++) {
        var item = res["data"]["records"][i];
        lst.add(UserInfo.fromJSON(item));
      }
    }

    setState(() {
      _friendsRequests = lst;
    });
  }

  _createRows() {
    _rows = new List<Row>();

    for (int i = 0; i < _resultRows; i++) {
      List<Widget> rowItems = new List<Widget>();
      for (int j = 0; j < _resultCols; j++) {
        GlobalKey<FriendResultItemState> _key = GlobalKey<FriendResultItemState>();
        _itemKeysList.add(_key);
        rowItems.add(FriendResultItem(
          key: _key,
          openProfile: _openProfile,
          openMail: _openMail,
          sendGift: _sendGift,
          removeFriend: _removeFriend,
        ));
      }

      Row row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowItems,
      );

      _rows.add(row);
    }
  }

  _getFriends({bool refresh = true, dynamic filter}) async {
    print("_onSearchHandler");
    setState(() {
      if (refresh) {
        _servicePageIndex = 1;
        _currentPageIndex = 1;
      }
    });

    dynamic options = {
      "recsPerPage": _serviceRecsPerPageFactor * _itemsPerPage,
      "page": _servicePageIndex,
      "getCount": refresh ? 1 : 0,
    };

    var friendsFilter;
    if (filter == null) {
      friendsFilter = {"online": null};
    } else {
      friendsFilter = filter;
    }
    var res = await _rpc.callMethod("Messenger.Client.getFriends", [friendsFilter, options]);

    if (res["status"] == "ok") {
      setState(() {
        if (res["data"]["count"] != null) {
          _totalResultsNum = res["data"]["count"];
          _totalPages = (res["data"]["count"] / _itemsPerPage).ceil();
        }

        var records = res["data"]["records"];
        print("records.length = " + records.length.toString());

        if (refresh) _itemsFetched.clear();

        for (int i = 0; i < records.length; i++) {
          FriendInfo record = FriendInfo.fromJSON(records[i]);
          _itemsFetched.add(record);
        }

        if (refresh)
          _updatePageData();
        else
          _updatePager();
      });
    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  _updatePageData() {
    for (int i = 0; i < _itemsPerPage; i++) {
      int fetchedResultsIndex = ((_currentPageIndex - 1) * _itemsPerPage) + i;
      if (fetchedResultsIndex < _itemsFetched.length)
        _itemKeysList[i].currentState.update(_itemsFetched[fetchedResultsIndex]);
      else
        _itemKeysList[i].currentState.clear();
    }

    _btnLeftKey.currentState.setDisabled(_currentPageIndex > 1);

    if (_currentPageIndex == _servicePageIndex * _serviceRecsPerPageFactor && _itemsFetched.length <= _currentPageIndex * _servicePageIndex * _itemsPerPage) {
      print("reached Max");
      _btnRightKey.currentState.setDisabled(true);
      _servicePageIndex++;
      _getFriends(refresh: false);
    }

    _updatePager();
  }

  _updatePager() {
    setState(() {
      _btnLeftKey.currentState.setDisabled(_currentPageIndex > 1);
      _btnLeftKey.currentState.setDisabled(_currentPageIndex == 1);
      _btnRightKey.currentState.setDisabled(_currentPageIndex == _totalPages);
    });
  }

  _onScrollLeft() {
    _currentPageIndex--;
    _updatePageData();
  }

  _onScrollRight() {
    _currentPageIndex++;
    _updatePageData();
  }

  _onAccept(int userId) async {
    var lst = [userId];
    var res = await _rpc.callMethod("Messenger.Client.acceptFriendshipRequest", [lst]);
    print(res);
    if (res["status"] == "ok") {
      _getFriends();
      _fetchFriendsRequests();
    } else {
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate(res["errorMsg"]));
    }
  }

  _onReject(int userId, String username) async {
    AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: Utils.instance.format(
          AppLocalizations.of(context).translateWithArgs("rejectQuest", [username]),
          ["<b>|</b>"],
        ),
        callbackAction: (retValue) async {
          if (retValue == 1) {
            var lst = [
              [userId, 0]
            ];
            var res = await _rpc.callMethod("Messenger.Client.rejectFriendshipRequest", [lst]);
            print(res);
            if (res["status"] == "ok") {
              _fetchFriendsRequests();
            } else {
              AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate(res["errorMsg"]));
            }
          }
        },
        dialogButtonChoice: AlertChoices.OK_CANCEL);
  }

  _onBlock(int userId, String username) async {
    AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: Utils.instance.format(
          AppLocalizations.of(context).translateWithArgs("blockQuestion", [username]),
          ["<b>|</b>"],
        ),
        callbackAction: (retValue) async {
          if (retValue == 1) {
            var lst = [
              [userId, 1]
            ];
            var res = await _rpc.callMethod("Messenger.Client.rejectFriendshipRequest", [lst]);
            print(res);
            if (res["status"] == "ok") {
              _fetchFriendsRequests();
            } else {
              AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate(res["errorMsg"]));
            }
          }
        },
        dialogButtonChoice: AlertChoices.OK_CANCEL);
  }

  _onAcceptAll() {
    print("accept all");
    AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("approveAllQuest"),
        callbackAction: (retValue) async {
          if (retValue == 1) {
            var userIds = _friendsRequests.map((e) => int.parse(e.userId.toString())).toList();
            print(userIds);
            var res = await _rpc.callMethod("Messenger.Client.acceptFriendshipRequest", [userIds]);
            print(res);
            if (res["status"] == "ok") {
              _fetchFriendsRequests();
              _getFriends();
            } else {
              AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate(res["errorMsg"]));
            }
          }
        },
        dialogButtonChoice: AlertChoices.OK_CANCEL);
  }

  _openProfile(int userId) {
    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userId, callbackAction: (retValue) {});
  }

  _openMail(String username) {
    PopupManager.instance.show(context: context, popup: PopupType.MailNew, options: username, callbackAction: (retValue) {});
  }

  _sendGift(String username) {
    PopupManager.instance.show(context: context, popup: PopupType.Gifts, options: username, headerOptions: username, callbackAction: (retValue) {});
  }

  _removeFriend(String username, int userId) async {
    AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: Utils.instance.format(
          AppLocalizations.of(context).translateWithArgs("deleteQuest", [username]),
          ["<b>|</b>"],
        ),
        callbackAction: (retValue) async {
          if (retValue == 1) {
            var res = await _rpc.callMethod("Messenger.Client.removeFriend", [userId, 0]);
            print(res);
            if (res["status"] == "ok") {
              _getFriends();
              AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("removeFriend"));
            } else {
              AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate(res["errorMsg"]));
            }
          }
        },
        dialogButtonChoice: AlertChoices.OK_CANCEL);
  }

  _onRejectAll() {
    print("reject all");

    AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("rejectAllQuest"),
        callbackAction: (retValue) async {
          if (retValue == 1) {
            var userIds = _friendsRequests.map((e) => int.parse(e.userId.toString())).toList();
            var lst = [];
            userIds.forEach((id) {
              lst.add([id, 0]);
            });
            print(lst);
            var res = await _rpc.callMethod("Messenger.Client.rejectFriendshipRequest", [lst]);
            print(res);
            if (res["status"] == "ok") {
              _fetchFriendsRequests();
            } else {
              AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate(res["errorMsg"]));
            }
          }
        },
        dialogButtonChoice: AlertChoices.OK_CANCEL);
  }

  getFieldsInputDecoration() {
    return InputDecoration(
      prefixIcon: Icon(
        FontAwesomeIcons.search,
        size: 20,
      ),
      fillColor: Color(0xffffffff),
      filled: false,
      enabledBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
      errorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
      focusedBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xff9598a4), width: 2)),
      focusedErrorBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(7.0), borderSide: new BorderSide(color: Color(0xffff0000), width: 1)),
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 5, top: 10, bottom: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context).translate("lblFriendsReq"),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff393e54),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  height: 390,
                  width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff9598a4),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(7))),
                  padding: EdgeInsets.all(3),
                  // color: Colors.black,
                  child: DraggableScrollbar(
                    alwaysVisibleScrollThumb: true,
                    heightScrollThumb: 100.0,
                    backgroundColor: Theme.of(context).backgroundColor,
                    scrollThumbBuilder: (
                        Color backgroundColor,
                        Animation<double> thumbAnimation,
                        Animation<double> labelAnimation,
                        double height, {
                          Text labelText,
                          BoxConstraints labelConstraints,
                        }) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xff616161),
                          borderRadius: BorderRadius.circular(3.5),
                        ),
                        height: 100,
                        width: 7.0,
                      );
                    },
                    controller: _friendsRequestsScrollController,
                    child: ListView.builder(
                        controller: _friendsRequestsScrollController,
                        shrinkWrap: true,
                        itemCount: _friendsRequests.length,
                        itemBuilder: (BuildContext context, int index) {
                          UserInfo user = _friendsRequests[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
                            child: Column(
                              children: [
                                FriendRequestRenderer(
                                  userInfo: user,
                                  selected: false,
                                  onSelected: (username) {},
                                  onOpenProfile: (userId) {
                                    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: int.parse(userId.toString()), callbackAction: (retValue) {});
                                  },
                                  onAccept: _onAccept,
                                  onReject: _onReject,
                                  onBlock: _onBlock,
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: GestureDetector(
                        onTap: () => _onAcceptAll(),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 200,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Color(0xff3c8d40),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 45),
                                  child: Text(
                                    AppLocalizations.of(context).translate("approveAll"),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset("assets/images/friends/addAll.png"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onRejectAll(),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          width: 200,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Color(0xfff7a738),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 45),
                                child: Text(
                                  AppLocalizations.of(context).translate("rejectAll"),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: Container(
                                  width: 17,
                                  height: 17,
                                  child: Image.asset("assets/images/friends/removeAll.png"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () => PopupManager.instance.show(context: context, popup: PopupType.Settings, options: {"park_at": "blocked"}, callbackAction: (v) {}),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          width: 200,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Color(0xff9fbfff),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 45),
                                child: Text(
                                  AppLocalizations.of(context).translate("btnBlocked"),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: Container(
                                  width: 17,
                                  height: 17,
                                  child: Image.asset("assets/images/friends/blocked.png"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          height: 30,
                          width: 180,
                          child: TextField(
                            focusNode: _searchUsernameFocusNode,
                            controller: _searchUsernameController,
                            onSubmitted: (txt) => _searchByUsername(),
                            decoration: getFieldsInputDecoration(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchUsernameController.clear();
                          });
                          _getFriends();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, top: 15),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Text(
                              AppLocalizations.of(context).translate("clear"),
                              style: TextStyle(
                                color: Color(0xff393e54),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 25),
                        child: Text(
                          "${AppLocalizations.of(context).translate("friends_sum")}: ${_totalResultsNum}",
                          style: TextStyle(
                            color: Color(0xff393e54),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _rows,
                ),
                Opacity(
                  opacity: _itemsFetched.length > 0 ? 1 : 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ZButton(
                        key: _btnLeftKey,
                        iconData: Icons.arrow_back_ios,
                        iconColor: Colors.blue,
                        iconSize: 20,
                        clickHandler: _onScrollLeft,
                        startDisabled: true,
                        iconPosition: ZButtonIconPosition.left,
                        hasBorder: false,
                      ),
                      Text(
                        AppLocalizations.of(context).translate("page"),
                        style: TextStyle(
                          color: Color(0xff393e54),
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        _currentPageIndex.toString(),
                        style: TextStyle(
                          color: Color(0xff393e54),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context).translate("from"),
                        style: TextStyle(
                          color: Color(0xff393e54),
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        _totalPages.toString(),
                        style: TextStyle(
                          color: Color(0xff393e54),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 5),
                      ZButton(
                        key: _btnRightKey,
                        iconData: Icons.arrow_forward_ios,
                        iconColor: Colors.blue,
                        iconSize: 20,
                        clickHandler: _onScrollRight,
                        startDisabled: true,
                        iconPosition: ZButtonIconPosition.right,
                        hasBorder: false,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
