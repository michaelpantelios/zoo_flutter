import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_flutter/apps/mail/mail_results_row.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/mail/mail_info.dart';
import 'package:zoo_flutter/models/mail/mail_message_info.dart';
import 'package:zoo_flutter/models/messenger/friend_info.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/simple_user_renderer.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class Mail extends StatefulWidget {
  final Size size;
  final Function(bool value) setBusy;
  Mail({@required this.size, @required this.setBusy});
  @override
  _MailState createState() => _MailState();
}

class _MailState extends State<Mail> {
  List<bool> inboxOutboxSelection = List.generate(2, (index) => false);
  int _totalUnreadOutbox = 0;
  int _totalUnreadInbox = 0;
  RPC _rpc;
  List<FriendInfo> _friends = [];
  UserInfo _selectedUser;
  int _rowsPerPage;
  int _totalPages = 0;
  int _currentPage = 1;
  int _currentServicePage = 1;
  int _serviceRecsPerPageFactor = 10;
  List<Widget> _rows = new List<Widget>();
  List<GlobalKey<MailResultsRowState>> _rowKeys = new List<GlobalKey<MailResultsRowState>>();
  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();
  int _totalMailsNum;
  List<MailInfo> _mailsFetched = [];
  dynamic _selectedMail;
  double _mailListHeight = 300;
  MailMessageInfo _selectedMailMessageInfo;
  List<String> _bodyTagsToRemove = ['<TEXTFORMAT LEADING="2">', "</TEXTFORMAT>"];

  @override
  void initState() {
    super.initState();
    inboxOutboxSelection[0] = true;
    _rpc = RPC();

    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rowsPerPage = (_mailListHeight / MailResultsRow.myHeight).floor();

    for (int i = 0; i < _rowsPerPage; i++) {
      GlobalKey<MailResultsRowState> _key = GlobalKey<MailResultsRowState>();
      _rowKeys.add(_key);
      _rows.add(MailResultsRow(key: _key, onSubjectTap: _onMailTitleTap, index: i));
    }
    _getMailList(true);
  }

  _onMailTitleTap(dynamic mailId, GlobalKey<MailResultsRowState> key) async {
    print("clicked on mail: " + mailId.toString());
    key.currentState.setRead(true);

    for (int i = 0; i < _rowsPerPage; i++) {
      _rowKeys[i].currentState.setSelected(_rowKeys[i] == key);
    }
    setState(() {
      _selectedMail = mailId;
    });

    var res = await _rpc.callMethod("Mail.Main.getMessage", [mailId]);
    print(res);
    if (res["status"] == "ok") {
      setState(() {
        if (inboxOutboxSelection[0]) {
          _totalUnreadInbox--;
        } else {
          _totalUnreadOutbox--;
        }

        _selectedMailMessageInfo = MailMessageInfo.fromJSON(res["data"]);
      });
    }
  }

  String _parseHtmlString(String htmlString) {
    String input = htmlString;
    input = input.replaceAll('<TEXTFORMAT LEADING="2">', "").replaceAll("</TEXTFORMAT>", "");
    return input;
  }

  _onPreviousPage() {
    _currentPage--;
    _updatePageData();
  }

  _onNextPage() {
    _currentPage++;
    _updatePageData();
  }

  _updatePageData() {
    for (int i = 0; i < _rowsPerPage; i++) {
      _rowKeys[i].currentState.setSelected(false);

      int fetchedMailIndex = ((_currentPage - 1) * _rowsPerPage) + i;
      if (fetchedMailIndex < _mailsFetched.length)
        _rowKeys[i].currentState.update(_mailsFetched[fetchedMailIndex]);
      else
        _rowKeys[i].currentState.clear();
    }

    _btnLeftKey.currentState.setDisabled(_currentPage > 1);

    if (_currentPage == _currentServicePage * _serviceRecsPerPageFactor && _mailsFetched.length <= _currentPage * _currentServicePage * _rowsPerPage) {
      print("reached Max");
      _btnRightKey.currentState.setDisabled(true);
      _currentServicePage++;
      _getMailList(false);
    }

    _updatePager();
  }

  _updatePager() {
    setState(() {
      _btnLeftKey.currentState.setDisabled(_currentPage > 1);
      _btnLeftKey.currentState.setDisabled(_currentPage == 1);
      _btnRightKey.currentState.setDisabled(_currentPage == _totalPages);
    });
  }

  _fetchData() async {
    var res = await _rpc.callMethod("Messenger.Client.getFriends", [
      {"online": null}
    ]);
    print(res);
    List<FriendInfo> lst = [];
    if (res["status"] == "ok") {
      for (var i = 0; i < res["data"]["records"].length; i++) {
        var item = res["data"]["records"][i];
        lst.add(FriendInfo.fromJSON(item));
      }
    }

    setState(() {
      _friends = lst;
    });
  }

  _getMailList(bool refresh) async {
    print("_getMailList");
    if (refresh) {
      _currentServicePage = 1;
      _currentPage = 1;
    }
    setState(() {
      _selectedMailMessageInfo = null;
    });

    bool inbox = inboxOutboxSelection[0] == true;
    int index = inbox ? 0 : 1;
    String serviceFunc = index == 0 ? "getInbox" : "getOutbox";

    var options = {};
    options["recsPerPage"] = _serviceRecsPerPageFactor * _rowsPerPage;
    options["page"] = _currentServicePage;
    options["getCount"] = 1;
    var res = await _rpc.callMethod("Mail.Main.$serviceFunc", [options]);

    // print("_requestData : ${serviceFunc}");
    // print(res);

    if (res["status"] == "ok") {
      if (res["data"]["count"] != null) {
        _totalMailsNum = res["data"]["count"];
        _totalPages = (res["data"]["count"] / _rowsPerPage).ceil();
      }

      var records = res["data"]["records"];

      if (refresh) _mailsFetched.clear();

      for (int i = 0; i < records.length; i++) {
        MailInfo mailInfo = MailInfo.fromJSON(records[i]);
        _mailsFetched.add(mailInfo);
      }

      if (inbox) {
        setState(() {
          _totalUnreadInbox = _mailsFetched.where((element) => element.read == 0).length;
        });
      } else {
        setState(() {
          _totalUnreadOutbox = _mailsFetched.where((element) => element.read == 0).length;
        });
      }

      if (refresh)
        _updatePageData();
      else
        _updatePager();
    } else {
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("mail_${res["errorMsg"]}"));
    }
  }

  _normalizeTitle(MailMessageInfo data) {
    if (data.type == "gift") {
      return AppLocalizations.of(context).translate("app_gifts_${data.subject}_subject");
    }

    return data.subject;
  }

  static getGiftPath(String id) {
    return "assets/images/gifts/$id-icon.png";
  }

  _normalizeSelectedBody() {
    var str = "";
    if (_selectedMailMessageInfo.type == "gift") {
      str = "<img src=${getGiftPath(_selectedMailMessageInfo.body['id'].toString())}></img>";
      str += _parseHtmlString(_selectedMailMessageInfo.body["msg"]);
    } else {
      str = _parseHtmlString(_selectedMailMessageInfo.body);
    }

    return str;
  }

  _deleteMessage() async {
    if (_selectedMailMessageInfo == null) {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate(
          "mail_noSelection",
        ),
      );
    } else {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate("mail_deleteMails"),
        callbackAction: (retValue) async {
          if (retValue == 1) {
            bool inbox = inboxOutboxSelection[0];
            var lstMsgIds = [_selectedMailMessageInfo.id];

            var res = await _rpc.callMethod("Mail.Main.deleteMessages", [lstMsgIds, inbox ? "inbox" : "outbox"]);
            print(res);

            if (res["status"] == "ok") {
              _getMailList(true);
            } else {
              AlertManager.instance.showSimpleAlert(
                context: context,
                bodyText: AppLocalizations.of(context).translate("mail_${res["errorMsg"]}"),
              );
            }
          }
        },
        dialogButtonChoice: AlertChoices.OK_CANCEL,
      );
    }
  }

  _ignoreUser() async {
    if (_selectedMailMessageInfo == null) {
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translate(
          "mail_noUserSelected",
        ),
      );
    } else {
      bool inbox = inboxOutboxSelection[0];
      var usernameToIgnore = inbox ? _selectedMailMessageInfo.from.username : _selectedMailMessageInfo.to.username;
      var useridToIgnore = inbox ? _selectedMailMessageInfo.from.userId.toString() : _selectedMailMessageInfo.to.userId.toString();
      AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translateWithArgs("mail_userIgnore", [usernameToIgnore]),
        callbackAction: (retValue) async {
          if (retValue == 1) {
            print("ignore!!!");

            var res = await _rpc.callMethod("Messenger.Client.addBlocked", [useridToIgnore]);
            print(res);

            if (res["status"] == "ok") {
              AlertManager.instance.showSimpleAlert(
                context: context,
                bodyText: AppLocalizations.of(context).translate("mail_userIgnored"),
                callbackAction: (retValue) async {
                  if (retValue == 1) {
                    print("delete messages also!");

                    var mailsFromIgnoreUser;
                    if (inbox) {
                      mailsFromIgnoreUser = _mailsFetched.where((element) => element.from.username == usernameToIgnore).toList();
                    } else {
                      mailsFromIgnoreUser = _mailsFetched.where((element) => element.to.username == usernameToIgnore).toList();
                    }

                    var lstMsgIds = mailsFromIgnoreUser.map((e) => e.id).toList();

                    var res = await _rpc.callMethod("Mail.Main.deleteMessages", [lstMsgIds, inbox ? "inbox" : "outbox"]);
                    print(res);

                    if (res["status"] == "ok") {
                      _getMailList(true);
                    } else {
                      AlertManager.instance.showSimpleAlert(
                        context: context,
                        bodyText: AppLocalizations.of(context).translate("mail_${res["errorMsg"]}"),
                      );
                    }
                  }
                },
                dialogButtonChoice: AlertChoices.OK_CANCEL,
              );
            }
          }
        },
        dialogButtonChoice: AlertChoices.OK_CANCEL,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("inbox clicked!");
                            setState(() {
                              inboxOutboxSelection[0] = true;
                              inboxOutboxSelection[1] = false;
                            });
                            _getMailList(true);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              width: 200,
                              height: 25,
                              decoration: BoxDecoration(
                                color: inboxOutboxSelection[0] ? Color(0xff9fbfff) : Color(0xffe4e6e9),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      "${AppLocalizations.of(context).translate("mail_inbox")}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: inboxOutboxSelection[0] ? Colors.white : Color(0xffbabbbd),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${_totalUnreadInbox > 0 ? _totalUnreadInbox : ""}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: inboxOutboxSelection[0] ? Colors.white : Color(0xffbabbbd),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset(
                                        "assets/images/mail/mail_inbox.png",
                                        color: inboxOutboxSelection[0] ? Color(0xffffffff) : Color(0xffbabbbd),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            print("outbox clicked!");
                            setState(() {
                              inboxOutboxSelection[1] = true;
                              inboxOutboxSelection[0] = false;
                            });
                            _getMailList(true);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              width: 200,
                              height: 25,
                              decoration: BoxDecoration(
                                color: inboxOutboxSelection[1] ? Color(0xff9fbfff) : Color(0xffe4e6e9),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      AppLocalizations.of(context).translate("mail_sent"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: inboxOutboxSelection[1] ? Colors.white : Color(0xffbabbbd),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${_totalUnreadOutbox > 0 ? _totalUnreadOutbox : ""}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: inboxOutboxSelection[1] ? Colors.white : Color(0xffbabbbd),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset(
                                        "assets/images/mail/mail_outbox.png",
                                        color: inboxOutboxSelection[1] ? Color(0xffffffff) : Color(0xffbabbbd),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 175,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("new message");
                            PopupManager.instance.show(context: context, popup: PopupType.MailNew, callbackAction: (r) {});
                          },
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
                                  Expanded(
                                    child: Text(
                                      AppLocalizations.of(context).translate("mail_btnNew"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset("assets/images/mail/mail_write.png"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        GestureDetector(
                          onTap: () {
                            print("reply");
                            if (_selectedMailMessageInfo == null) {
                              AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("mail_noSelection"));
                            } else {
                              PopupManager.instance.show(context: context, popup: PopupType.MailReply, options: _selectedMailMessageInfo, callbackAction: (r) {});
                            }
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              width: 200,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Color(0xff64abff),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      AppLocalizations.of(context).translate("mail_btnReply"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset("assets/images/mail/mail_reply.png"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        GestureDetector(
                          onTap: () {
                            print("delete");
                            _deleteMessage();
                          },
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
                                  Expanded(
                                    child: Text(
                                      AppLocalizations.of(context).translate("mail_btnDelete"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset("assets/images/mail/mail_delete.png"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        GestureDetector(
                          onTap: () {
                            print("ignore");
                            _ignoreUser();
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              width: 200,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Color(0xffdc5b42),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      AppLocalizations.of(context).translate("mail_btnBlock"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset("assets/images/mail/mail_ignore.png"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                height: 320,
                                width: 166,
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
                                child: Scrollbar(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _friends.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        UserInfo user = _friends[index].user;
                                        return SimpleUserRenderer(
                                          width: 100,
                                          userInfo: user,
                                          selected: _selectedUser?.username == user.username,
                                          onSelected: (username) {
                                            setState(() {
                                              _selectedUser = _friends.firstWhere((element) => element.user.username == username).user;
                                            });
                                          },
                                          onOpenProfile: (userId) {
                                            PopupManager.instance.show(context: context, popup: PopupType.Profile, options: int.parse(userId.toString()), callbackAction: (retValue) {});
                                          },
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 555,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color(0xff9fbfff),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: 130,
                              height: 28,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  inboxOutboxSelection[0] ? AppLocalizations.of(context).translate("mail_from") : AppLocalizations.of(context).translate("mail_to"),
                                  style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: 13),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                          Container(
                              width: 332,
                              height: 28,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  AppLocalizations.of(context).translate("mail_subject"),
                                  style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: 13),
                                ),
                              )),
                          Container(
                              width: 92,
                              height: 28,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  AppLocalizations.of(context).translate("mail_date"),
                                  style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: 13),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(child: Column(children: _rows)),
                    Opacity(
                      opacity: _totalPages > 0 ? 1 : 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ZButton(
                            key: _btnLeftKey,
                            iconData: Icons.arrow_back_ios,
                            iconColor: Colors.blue,
                            iconSize: 20,
                            clickHandler: _onPreviousPage,
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
                            _currentPage.toString(),
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
                            clickHandler: _onNextPage,
                            startDisabled: true,
                            iconPosition: ZButtonIconPosition.right,
                            hasBorder: false,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: 321,
                        width: 550,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff9598a4),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xfff8f8f9),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5, left: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${AppLocalizations.of(context).translate(inboxOutboxSelection[0] ? "mail_from" : "mail_to")}:",
                                          style: TextStyle(
                                            color: Color(0xff393e54),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Container(
                                          padding: inboxOutboxSelection[0] ? const EdgeInsets.only(left: 83) : const EdgeInsets.only(left: 75),
                                          child: _selectedMailMessageInfo == null
                                              ? Container()
                                              : SimpleUserRenderer(
                                                  userInfo: inboxOutboxSelection[0] ? _selectedMailMessageInfo.from : _selectedMailMessageInfo.to,
                                                  selected: false,
                                                  onSelected: (username) {},
                                                  onOpenProfile: (String userId) {
                                                    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: int.parse(userId.toString()), callbackAction: (retValue) {});
                                                  },
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, left: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${AppLocalizations.of(context).translate("mail_subject")}:",
                                          style: TextStyle(
                                            color: Color(0xff393e54),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(left: 75),
                                          child: _selectedMailMessageInfo == null
                                              ? Container()
                                              : Text(
                                                  _normalizeTitle(_selectedMailMessageInfo),
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, left: 5, bottom: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${AppLocalizations.of(context).translate("mail_attachments")}:",
                                          style: TextStyle(
                                            color: Color(0xff393e54),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 11),
                                          child: _selectedMailMessageInfo == null
                                              ? Container()
                                              : Text(
                                                  _selectedMailMessageInfo.attachments.length == 0 ? "--" : "${_selectedMailMessageInfo.attachments.length}",
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0, left: 5),
                              child: SizedBox(
                                height: 215,
                                child: _selectedMailMessageInfo == null
                                    ? Container()
                                    : SingleChildScrollView(
                                        child: HtmlWidget(
                                          _normalizeSelectedBody(),
                                          textStyle: TextStyle(color: Colors.black),
                                          onTapUrl: (value) async {
                                            if (await canLaunch(value)) {
                                              await launch(value);
                                            } else {
                                              throw 'Could not launch $value';
                                            }
                                          },
                                        ),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
