import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/apps/forum/forum_new_post.dart';
import 'package:zoo_flutter/apps/forum/forum_user_renderer.dart';
import 'package:zoo_flutter/apps/forum/models/forum_category_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_reply_record_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_reply_view_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_topic_view_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_user_model.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:html/parser.dart';
import 'package:zoo_flutter/utils/utils.dart';

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
  int _serviceRepliesPerPage = 500;

  ForumTopicViewModel _topicViewInfo;
  ForumReplyViewModel _replyViewInfo;
  List<ForumReplyRecordModel> _replies;

  bool _contentFetched = false;
  int _repliesPerPage;

  GlobalKey _key = GlobalKey();
  double _tableHeight;
  double _tableRowHeight = 50;
  ForumReplyViewModel _selectedReply;
  ViewStatus _viewStatus = ViewStatus.topicView;
  bool _showNewReply = false;

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  _onNewReplyCloseHandler() {
    setState(() {
      _showNewReply = false;
    });
  }

  @override
  void initState() {
     _rpc = RPC();
     _replies = new List<ForumReplyRecordModel>();
     _repliesPerPage = ((widget.myHeight - 100) / _tableRowHeight).floor();

    super.initState();

    getTopic();
    getReplies();
  }

  getTopic() async {
    var res = await _rpc.callMethod("OldApps.Forum.getTopic",  widget.topicId );

    if (res["status"] == "ok"){
      // print("topic: ");
      print(res["data"]);

      setState(() {
        _topicViewInfo = ForumTopicViewModel.fromJSON(res["data"]);
        _contentFetched = true;
      });

    } else {
      print("ERROR");
      print(res["status"]);
    }
    
  }
  
  getReplies() async {
    var options = {
      "page" : _currentServiceRepliesPage,
      "recsPerPage" : _serviceRepliesPerPage
    };

    var res = await _rpc.callMethod('OldApps.Forum.getReplyList', widget.topicId, options);

    if (res["status"] == "ok"){
      // print("replies List: ");
      // print(res["data"]);
      var records = res["data"]["records"];
      setState(() {
        for(int i=0; i<records.length; i++){
          ForumReplyRecordModel reply = ForumReplyRecordModel.fromJSON(records[i]);
          _replies.add(reply);
        }

      });
    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  getReply(dynamic replyId) async {
    var res = await _rpc.callMethod("OldApps.Forum.getReply",  replyId );

    if (res["status"] == "ok"){
      print("reply: ");
      print(res["data"]);

      setState(() {
        _replyViewInfo = ForumReplyViewModel.fromJSON(res["data"]);
        print("topic body: "+_replyViewInfo.body);
        _viewStatus = ViewStatus.replyView;
        _contentFetched = true;
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
                child: Text(AppLocalizations.of(context).translate("app_forum_column_from"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Text(AppLocalizations.of(context).translate("app_forum_column_title"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Text(AppLocalizations.of(context).translate("app_forum_column_date") + ":", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Text(AppLocalizations.of(context).translate("app_forum_topic_view_views") + ":", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
              )
            ]),
            SizedBox(width: 5),
            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(padding: EdgeInsets.symmetric(vertical: 2), child: Text(_viewStatus == ViewStatus.topicView ? _topicViewInfo.from["username"] : _replyViewInfo.from["username"], style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left)),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: _viewStatus == ViewStatus.topicView
                      ? Text(_topicViewInfo.subject, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left)
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _viewStatus = ViewStatus.topicView;
                            });
                          },
                          child: Text(_topicViewInfo.subject, style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.normal)))),
              Container(padding: EdgeInsets.symmetric(vertical: 2), child: Text(_viewStatus == ViewStatus.topicView ? Utils.instance.getNiceForumDate(dd: _topicViewInfo.date.toString()) : Utils.instance.getNiceForumDate(dd: _replyViewInfo.date.toString()), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left)),
              Container(padding: EdgeInsets.symmetric(vertical: 2), child: Text(_viewStatus == ViewStatus.topicView ? _topicViewInfo.views.toString() : _replyViewInfo.views.toString(), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left))
            ])
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    _tableHeight = MediaQuery.of(context).size.height - 120;

    final _dtSource = RepliesDataTableSource(replies: _replies, onReplyViewTap: (replyId) => getReply(replyId));

    return !_contentFetched ? Container() :  Stack(key: _key, children: [
      Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 250,
            child: PaginatedDataTable(columns: [
              DataColumn(
                label: Container(),
              )
            ], source: _dtSource, header: Container(margin: EdgeInsets.symmetric(vertical: 5), child: Text(AppLocalizations.of(context).translate("app_forum_topic_view_user_replies"), style: Theme.of(context).textTheme.headline2)), headingRowHeight: 10, rowsPerPage: _repliesPerPage),
          ),
          Expanded(
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
                            child: Html(
                                data:
                                _viewStatus == ViewStatus.topicView
                                    ? _parseHtmlString(_topicViewInfo.body.toString())  :
                                _parseHtmlString(_replyViewInfo.body.toString())
                                , style: {
                              "html": Style(backgroundColor: Colors.white, color: Colors.black),
                            })),
                        )
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _showNewReply = true;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.reply,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 5), child: Text(AppLocalizations.of(context).translate("app_forum_topic_view_reply"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))
                                    ],
                                  )),
                              // FlatButton(
                              //     onPressed: () {
                              //       print("report abuse");
                              //     },
                              //     child: Row(
                              //       children: [
                              //         Icon(
                              //           Icons.do_not_disturb_alt,
                              //           color: Colors.red,
                              //           size: 20,
                              //         ),
                              //         Padding(padding: EdgeInsets.only(left: 5), child: Text(AppLocalizations.of(context).translate("app_forum_topic_view_btn_report_abuse"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))
                              //       ],
                              //     )),
                              Expanded(child: Container()),
                              FlatButton(
                                  onPressed: () {
                                    print("return");
                                    widget.onReturnToForumView();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 5), child: Text(AppLocalizations.of(context).translate("app_forum_topic_view_btn_return"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))
                                    ],
                                  ))
                            ],
                          ))
                    ],
                  )))
        ],
      )),
      _showNewReply ? ForumNewPost(
          parentSize: new Size(widget.myWidth, widget.myHeight),
          forumInfo: widget.forumInfo,
          parent: widget.topicId,
          onCloseBtnHandler: _onNewReplyCloseHandler)
          : Container()
    ]);
  }
}

typedef OnReplyViewTap = void Function(int replyId);

class RepliesDataTableSource extends DataTableSource {
  RepliesDataTableSource({@required this.replies, @required this.onReplyViewTap});

  final List<ForumReplyRecordModel> replies;
  final OnReplyViewTap onReplyViewTap;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => replies.length;

  @override
  int get selectedRowCount => 0;

  getRowIndexRenderer(int index) {
    return Text(index.toString() + ".", style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.normal));
  }

  getOpenReplyButton(int replyId) {
    return IconButton(
      icon: Icon(Icons.arrow_forward, size: 25, color: Colors.orange),
      onPressed: () {
        onReplyViewTap(replyId);
      },
    );
  }

  @override
  DataRow getRow(int index) {
    if (index >= replies.length) {
      return null;
    }

    final reply = replies[index];

    List<DataCell> cells = new List<DataCell>();

    cells.add(new DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getRowIndexRenderer(index),
        ForumUserRenderer(userInfo: ForumUserModel.fromJSON(reply.from)),
        Expanded(child: Container()),
        getOpenReplyButton(replies[index].id)],
    )));

    DataRow row = new DataRow(cells: cells);

    return row;
  }
}
