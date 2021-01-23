import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/models/friends/friend_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/widgets/simple_user_renderer.dart';

import '../../main.dart';

class Messenger extends StatefulWidget {
  Messenger({Key key, this.options, this.onClose, this.setBusy}) : super(key: key);

  final dynamic options;
  final Function(dynamic retValue) onClose;
  final Function(bool value) setBusy;

  MessengerState createState() => MessengerState();
}

class MessengerState extends State<Messenger> {
  MessengerState();

  FocusNode _searchUsernameFocusNode = FocusNode();
  TextEditingController _searchUsernameController = TextEditingController();
  ScrollController _friendsScrollController;
  ScrollPosition _currentScrollPos;
  UserInfo _selectedUser;
  int _friendRequests = 1;

  RPC _rpc;
  List<FriendInfo> _friends = [];
  double _scrollThreshold = 50;
  int _currentPage = 1;
  int _recsPerPage = 20;
  int _totalFriends = -1;
  double _friendsListHeight = 0;
  double _friendsListWidth = 0;

  @override
  void initState() {
    super.initState();
    _friendsListHeight = Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding - 80;
    _friendsListWidth = 240;
    _friendsScrollController = ScrollController();
    _rpc = RPC();

    _recsPerPage = 2 * (_friendsListHeight / 27).floor();
    print('_recsPerPage: ${_recsPerPage}');
    _fetchData();
  }

  @override
  void dispose() {
    _friendsScrollController.dispose();
    super.dispose();
  }

  _scrollListener() async {
    if (_friendsScrollController.position.pixels > (_friendsScrollController.position.maxScrollExtent - _scrollThreshold) && _friends.length < _totalFriends) {
      _friendsScrollController.removeListener(_scrollListener);

      _currentPage++;
      _currentScrollPos = _friendsScrollController.position;
      if (_searchUsernameController.text != null && _searchUsernameController.text.isNotEmpty)
        await _fetchData(username: _searchUsernameController.text);
      else
        await _fetchData();
    }
  }

  _fetchData({String username}) async {
    if (_currentScrollPos != null) _friendsScrollController.detach(_currentScrollPos);

    var res;
    Map<String, dynamic> filter = {
      "online": null,
      "facebook": null,
    };
    print('username: $username');
    if (username != null) {
      filter["username"] = username;
    }

    res = await _rpc.callMethod("Messenger.Client.getFriends", [
      filter,
      {"page": _currentPage, "recsPerPage": _recsPerPage, "getCount": 1}
    ]);

    List<FriendInfo> lst = _friends.toList();
    if (res["status"] == "ok") {
      print('records: ${res["data"]["records"].length}');
      _totalFriends = res["data"]["count"];
      for (var i = 0; i < res["data"]["records"].length; i++) {
        var item = res["data"]["records"][i];
        var friend = FriendInfo.fromJSON(item);
        lst.add(friend);
      }
    }

    setState(() {
      _friends = lst;
    });
    if (!_friendsScrollController.hasListeners) _friendsScrollController.addListener(_scrollListener);

    if (_currentScrollPos != null) _friendsScrollController.attach(_currentScrollPos);
    _friendsScrollController.jumpTo(_friendsScrollController.position.minScrollExtent);
  }

  _searchByUsername() {
    print("search by username: ${_searchUsernameController.text}");
    _friends.clear();
    _currentPage = 1;
    _fetchData(username: _searchUsernameController.text);
    _searchUsernameFocusNode.requestFocus();
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
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: _friendsListWidth,
                child: TextField(
                  focusNode: _searchUsernameFocusNode,
                  controller: _searchUsernameController,
                  onSubmitted: (txt) => _searchByUsername(),
                  decoration: getFieldsInputDecoration(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        AppLocalizations.of(context).translate("mail_lblMyFriends"),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff393e54),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      height: _friendsListHeight,
                      width: _friendsListWidth,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff9598a4),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      padding: EdgeInsets.all(3),
                      // color: Colors.black,
                      child: DraggableScrollbar(
                        heightScrollThumb: 100,
                        controller: _friendsScrollController,
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
                              borderRadius: BorderRadius.circular(4.5),
                            ),
                            height: 100,
                            width: 9.0,
                          );
                        },
                        backgroundColor: Theme.of(context).backgroundColor,
                        child: ListView.builder(
                            controller: _friendsScrollController,
                            shrinkWrap: true,
                            itemCount: _friends.length,
                            itemBuilder: (BuildContext context, int index) {
                              UserInfo user = _friends[index].user;
                              return SimpleUserRenderer(
                                width: 130,
                                userInfo: user,
                                online: _friends[index].online == 1,
                                selected: _selectedUser?.username == user.username,
                                onSelected: (username) {
                                  setState(() {
                                    _selectedUser = _friends.firstWhere((element) => element.user.username == username).user;
                                  });
                                },
                                onOpenProfile: (userId) {},
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Html(
                data: AppLocalizations.of(context).translateWithArgs("messenger_friends_requests", ["<span color='#ff0000'>" + _friendRequests.toString() + "</span>"]),
                style: {
                  "html": Style(color: Colors.black, fontWeight: FontWeight.w500, fontSize: FontSize.medium),
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
