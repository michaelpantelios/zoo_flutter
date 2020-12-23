import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/apps/forum/forum_new_post.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/apps/forum/models/forum_category_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_reply_record_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_reply_view_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_topic_view_model.dart';
import 'package:zoo_flutter/apps/forum/forum_results_reply_row.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:html/parser.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';

typedef OnReturnToForumView = void Function();

enum ViewStatus { topicView, replyView }

class ForumTopicView extends StatefulWidget {
  ForumTopicView({Key key, @required this.forumInfo, @required this.topicId, @required this.onReturnToForumView, this.myWidth, this.myHeight});

  final ForumCategoryModel forumInfo;
  final dynamic topicId;
  final OnReturnToForumView onReturnToForumView;
  final double myWidth;
  final double myHeight;

  ForumTopicViewState createState() => ForumTopicViewState();
}

class ForumTopicViewState extends State<ForumTopicView> {
  ForumTopicViewState({Key key});

  RPC _rpc;
  int _currentServiceRepliesPage = 1;
  int _serviceRepliesPerPageFactor = 10;

  ForumTopicViewModel _topicViewInfo;
  ForumReplyViewModel _replyViewInfo;
  List<ForumReplyRecordModel> _repliesRecordsFetched;
  int _totalRepliesNum;

  bool _contentFetched = false;
  int _repliesPerPage;
  int _totalRepliesPages = 0;
  int _currentRepliesPage = 1;

  GlobalKey _key = GlobalKey();
  ForumReplyViewModel _selectedReply;
  ViewStatus _viewStatus = ViewStatus.topicView;
  bool _showNewReply = false;

  List<Widget> _repliesRows = new List<Widget>();
  List<GlobalKey<ForumResultsReplyRowState>> _repliesRowKeys = new List<GlobalKey<ForumResultsReplyRowState>>();

  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  _onPreviousPage() {
    _currentRepliesPage--;
    _updateRepliesPageData();
  }

  _onNextPage() {
    _currentRepliesPage++;
    _updateRepliesPageData();
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  _openNewReply(){
    print("_open New Reply ");
    if (!UserProvider.instance.logged) {
      PopupManager.instance.show(
          context: context,
          popup: PopupType.Login,
          callbackAction: (res) {
            if (res) {
              print("ok");
              _doOpenNewReply();
            }
          });
      return;
    }
    _doOpenNewReply();
  }

  _doOpenNewReply(){
    setState(() {
      _showNewReply = true;
    });
  }

  _onReportAbuse(BuildContext context){
    print("_onReportAbuse");
    if (!UserProvider.instance.logged) {
      PopupManager.instance.show(
          context: context,
          popup: PopupType.Login,
          callbackAction: (res) {
            if (res) {
              print("ok");
              _showAbuseAlert(context);
            }
          });
      return;
    }
    _showAbuseAlert(context);
  }

  _showAbuseAlert(BuildContext context){
    AlertManager.instance.showSimpleAlert(
      context: context,
      bodyText: AppLocalizations.of(context).translate("app_forum_abuse"),
      callbackAction:  (retValue) {
        if (retValue == AlertChoices.OK)
          _doSendAbuseReport(context);
      },
      dialogButtonChoice: AlertChoices.OK_CANCEL
    );
  }

  _doSendAbuseReport(BuildContext context) async {
    print("sent Abuse Report");
    var type = _viewStatus == ViewStatus.topicView ? "topic" : "reply";
    var messageId = _viewStatus == ViewStatus.topicView ? widget.topicId : _replyViewInfo.id;

    var res = await _rpc.callMethod('OldApps.Forum.reportAbuse', messageId, type);

    AlertManager.instance.showSimpleAlert(
          context: context,
          bodyText: AppLocalizations.of(context).translate( res["status"] == "ok" ? "app_forum_abuseOk" : "app_forum_error"));
  }

  @override
  void initState() {
    super.initState();
    _rpc = RPC();
    _repliesRecordsFetched = new List<ForumReplyRecordModel>();
    _repliesPerPage = ((widget.myHeight - 90) / ForumResultsReplyRow.myHeight).floor();

    print("repliesPerPage = " + _repliesPerPage.toString());

    for (int i = 0; i < _repliesPerPage; i++) {
      GlobalKey<ForumResultsReplyRowState> _key = new GlobalKey<ForumResultsReplyRowState>();
      _repliesRows.add(ForumResultsReplyRow(key: _key, onReplyClick: getReply));
      _repliesRowKeys.add(_key);
    }

    _getTopic();
    _getReplies();

  }

  _onNewReplyCloseHandler() {
    setState(() {
      _showNewReply = false;
    });
  }

  _getTopic() async {
    var res = await _rpc.callMethod("OldApps.Forum.getTopic", widget.topicId);

    if (res["status"] == "ok") {
      // print("topic: ");
      // print(res["data"]);

      setState(() {
        _topicViewInfo = ForumTopicViewModel.fromJSON(res["data"]);
        _contentFetched = true;
      });
    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  _getReplies({bool refresh = true}) async {
    print("_getReplies, refresh = " + refresh.toString());
    if (refresh) {
      _currentServiceRepliesPage = 1;
      _currentRepliesPage = 1;
    }

    var options = {"page": _currentServiceRepliesPage, "recsPerPage": _serviceRepliesPerPageFactor * _repliesPerPage, "getCount": refresh ? 1 : 0};

    var res = await _rpc.callMethod('OldApps.Forum.getReplyList', widget.topicId, options);

    if (res["status"] == "ok") {
      // print("replies Count: ");
      // print(res["data"]["count"].toString());
      if (res["data"]["count"] != null) {
        _totalRepliesNum = res["data"]["count"];
        _totalRepliesPages = (res["data"]["count"] / _repliesPerPage).ceil();
      }

      print("_totalRepliesPages = " + _totalRepliesPages.toString());
      var records = res["data"]["records"];

      if (refresh) _repliesRecordsFetched.clear();

      for (int i = 0; i < records.length; i++) {
        ForumReplyRecordModel reply = ForumReplyRecordModel.fromJSON(records[i]);
        _repliesRecordsFetched.add(reply);
      }

      if (refresh)
        _updateRepliesPageData();
      else
        _updatePager();

    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  _updateRepliesPageData() {
    print("_updateRepliesPageData");
    for (int i = 0; i < _repliesPerPage; i++) {
      int fetchedRepliesIndex = ((_currentRepliesPage - 1) * _repliesPerPage) + i;

      if (fetchedRepliesIndex < _repliesRecordsFetched.length)
        _repliesRowKeys[i].currentState.update(fetchedRepliesIndex, _repliesRecordsFetched[fetchedRepliesIndex]);
      else
        _repliesRowKeys[i].currentState.clear();
    }

    _btnLeftKey.currentState.setDisabled(_currentRepliesPage > 1);

    if (_currentRepliesPage == _currentServiceRepliesPage * _serviceRepliesPerPageFactor
        && _repliesRecordsFetched.length <= _currentRepliesPage * _currentServiceRepliesPage * _repliesPerPage) {
      _btnRightKey.currentState.setDisabled(true);
      _currentServiceRepliesPage++;
      _getReplies(refresh: false);
    }

    _updatePager();
  }

  _updatePager() {
    setState(() {
      if (_currentRepliesPage > 1) _btnLeftKey.currentState.setDisabled(false);

      if (_btnLeftKey.currentState != null) _btnLeftKey.currentState.setDisabled(_currentRepliesPage == 1);

      if (_btnRightKey.currentState != null) _btnRightKey.currentState.setDisabled(_currentRepliesPage == _totalRepliesPages);
    });
  }

  getReply(dynamic replyId) async {
    var res = await _rpc.callMethod("OldApps.Forum.getReply", replyId);

    if (res["status"] == "ok") {
      print("reply: ");
      print(res["data"]);

      setState(() {
        _replyViewInfo = ForumReplyViewModel.fromJSON(res["data"]);
        print("topic body: " + _replyViewInfo.body);
        _viewStatus = ViewStatus.replyView;
      });
    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  getTopicHeader() {
    return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 2),
                child:
                    Text(AppLocalizations.of(context).translate("app_forum_column_from"), style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2),
                child:
                    Text(AppLocalizations.of(context).translate("app_forum_column_title"), style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Text(AppLocalizations.of(context).translate("app_forum_column_date") + ":",
                    style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Text(AppLocalizations.of(context).translate("app_forum_topic_view_views") + ":",
                    style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
              )
            ]),
            SizedBox(width: 5),
            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text(_viewStatus == ViewStatus.topicView ? _topicViewInfo.from["username"] : _replyViewInfo.from["username"],
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left)),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: _viewStatus == ViewStatus.topicView
                      ? Text(_topicViewInfo.subject, style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.normal), textAlign: TextAlign.left)
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _viewStatus = ViewStatus.topicView;
                            });
                          },
                          child: Text(_topicViewInfo.subject, style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.normal, decoration: TextDecoration.underline)))),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                      _viewStatus == ViewStatus.topicView ? Utils.instance.getNiceForumDate(dd: _topicViewInfo.date.toString()) : Utils.instance.getNiceForumDate(dd: _replyViewInfo.date.toString()),
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.left)),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text(_viewStatus == ViewStatus.topicView ? _topicViewInfo.views.toString() : _replyViewInfo.views.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left))
            ])
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(key: _key, children: [
      Container(
          color: Colors.white,
          width: widget.myWidth,
          height: widget.myHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: ForumResultsReplyRow.myWidth + 20,
                  height: widget.myHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black38,
                              width: 1.0,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                              child: Text(AppLocalizations.of(context).translate("app_forum_topic_view_user_replies"),
                                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black38,
                              width: 1.0,
                            ),
                          ),
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.all(10),
                          child: Column(children: _repliesRows)),
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(3),
                                  width: 50,
                                  child: Tooltip(
                                      message: AppLocalizations.of(context).translate("previous_page"),
                                      child: ZButton(
                                        key: _btnLeftKey,
                                        iconData: Icons.arrow_back_ios,
                                        iconColor: Colors.blue,
                                        iconSize: 30,
                                        clickHandler: _onPreviousPage,
                                        startDisabled: true,
                                        hasBorder: false,
                                      ))),
                              Container(
                                height: 30,
                                width: 120,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Center(
                                        child: Html(data: AppLocalizations.of(context).translateWithArgs("pager_label_short", [_currentRepliesPage.toString(), _totalRepliesPages.toString()]), style: {
                                      "html": Style(backgroundColor: Colors.white, color: Colors.black, textAlign: TextAlign.center),
                                    }))),
                              ),
                              Container(
                                  width: 50,
                                  padding: EdgeInsets.all(3),
                                  child: ZButton(
                                    key: _btnRightKey,
                                    iconData: Icons.arrow_forward_ios,
                                    iconColor: Colors.blue,
                                    iconSize: 30,
                                    clickHandler: _onNextPage,
                                    hasBorder: false,
                                    startDisabled: true,
                                  ))
                            ],
                          ))
                    ],
                  )),
              !_contentFetched
                  ? Container()
                  : Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Column(
                            children: [
                              getTopicHeader(),
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Container(
                                    width: double.infinity,
                                    child:
                                        Html(data: _viewStatus == ViewStatus.topicView ? _parseHtmlString(_topicViewInfo.body.toString()) : _parseHtmlString(_replyViewInfo.body.toString()), style: {
                                      "html": Style(backgroundColor: Colors.white, color: Colors.black),
                                    })),
                              )),
                              Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: 140,
                                          height: 40,
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.blue[700],
                                              width: 1,
                                            ),
                                          ),
                                          child:  ZButton(
                                            clickHandler: () {
                                              _openNewReply();
                                            },
                                            buttonColor: Colors.white,
                                            iconData: Icons.reply,
                                            iconColor: Colors.blue[700],
                                            iconSize: 30,
                                            label: AppLocalizations.of(context).translate("app_forum_topic_view_reply"),
                                            labelStyle:  TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                                            hasBorder: false,
                                          )
                                      ),
                                      SizedBox(
                                        width: 5
                                      ),
                                      Container(
                                          width: 220,
                                          height: 40,
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 1,
                                            ),
                                          ),
                                          child:  ZButton(
                                            clickHandler: () {
                                              _onReportAbuse(context);
                                            },
                                            buttonColor: Colors.white,
                                            iconData: Icons.do_not_disturb_alt,
                                            iconColor: Colors.red,
                                            iconSize: 30,
                                            label: AppLocalizations.of(context).translate("app_forum_topic_view_btn_report_abuse"),
                                            labelStyle:  TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                                            hasBorder: false,
                                          )
                                      ),
                                      Expanded(child: Container()),
                                      Container(
                                        width: 140,
                                        height: 40,
                                        padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:  Colors.green[700],
                                              width: 1,
                                            ),
                                          ),
                                        child:  ZButton(
                                          clickHandler: () {
                                            print("return");
                                            widget.onReturnToForumView();
                                          },
                                          buttonColor: Colors.white,
                                          iconData: Icons.arrow_back,
                                          iconColor:  Colors.green[700],
                                          iconSize: 30,
                                          label: AppLocalizations.of(context).translate("app_forum_topic_view_btn_return"),
                                          labelStyle:  TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                                          hasBorder: false,
                                        )
                                      )
                                    ],
                                  ))
                            ],
                          )))
            ],
          )),
      _showNewReply ? ForumNewPost(parentSize: new Size(widget.myWidth, widget.myHeight), forumInfo: widget.forumInfo, parent: widget.topicId, onCloseBtnHandler: _onNewReplyCloseHandler) : Container()
    ]);
  }
}
