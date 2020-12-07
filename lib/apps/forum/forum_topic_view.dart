import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:zoo_flutter/apps/forum/forum_new_post.dart';
import 'package:zoo_flutter/apps/forum/forum_user_renderer.dart';
import 'package:zoo_flutter/apps/forum/models/forum_reply_model.dart';
import 'package:zoo_flutter/apps/forum/models/forum_topic_model.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';

typedef OnReturnToForumView = void Function();

enum ViewStatus { topicView, replyView }

class ForumTopicView extends StatefulWidget {
  ForumTopicView({Key key, @required this.topic, @required this.onReturnToForumView});

  final ForumTopicModel topic;
  final OnReturnToForumView onReturnToForumView;

  ForumTopicViewState createState() => ForumTopicViewState();
}

class ForumTopicViewState extends State<ForumTopicView> {
  ForumTopicViewState({Key key});

  GlobalKey _key = GlobalKey();
  Size size;
  UserInfo topicOwnerInfo;
  UserInfo replyOwnerInfo;
  List<ForumReplyModel> replies;
  double _tableHeight;
  double _tableRowHeight = 50;
  ForumReplyModel _selectedReply;
  ViewStatus _viewStatus = ViewStatus.topicView;
  bool showNewPost = false;

  _afterLayout(_) {
    final RenderBox renderBox = _key.currentContext.findRenderObject();

    size = renderBox.size;
  }

  onNewPostCloseHandler() {
    setState(() {
      showNewPost = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    topicOwnerInfo = DataMocker.users.where((user) => user.userId == widget.topic.ownerId).first;
    print("widget text:" + widget.topic.text);
    replies = DataMocker.forumReplies.where((reply) => reply.topicId == widget.topic.id).toList();

    super.initState();
  }

  onReplyViewTap(int replyId) {
    setState(() {
      _selectedReply = replies.where((reply) => reply.id == replyId).first;
      replyOwnerInfo = DataMocker.users.where((user) => user.userId == _selectedReply.ownerId).first;
      _viewStatus = ViewStatus.replyView;
    });
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
            SizedBox(width: 10),
            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(padding: EdgeInsets.symmetric(vertical: 2), child: Text(_viewStatus == ViewStatus.topicView ? topicOwnerInfo.username : replyOwnerInfo.username, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left)),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: _viewStatus == ViewStatus.topicView
                      ? Text(widget.topic.title, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left)
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _viewStatus = ViewStatus.topicView;
                            });
                          },
                          child: Text(widget.topic.title, style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.normal)))),
              Container(padding: EdgeInsets.symmetric(vertical: 2), child: Text(widget.topic.date.toString(), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left)),
              Container(padding: EdgeInsets.symmetric(vertical: 2), child: Text(widget.topic.views.toString(), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left))
            ])
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    _tableHeight = MediaQuery.of(context).size.height - 120;

    final _dtSource = RepliesDataTableSource(topicId: widget.topic.id, replies: replies, onReplyViewTap: (replyId) => onReplyViewTap(replyId));

    return Stack(key: _key, children: [
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
            ], source: _dtSource, header: Container(margin: EdgeInsets.symmetric(vertical: 5), child: Text(AppLocalizations.of(context).translate("app_forum_topic_view_user_replies"), style: Theme.of(context).textTheme.headline2)), headingRowHeight: 10, rowsPerPage: ((_tableHeight - 120) / _tableRowHeight).floor()),
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
                            child: Html(data: _viewStatus == ViewStatus.topicView ? widget.topic.text : _selectedReply.text, style: {
                              "html": Style(backgroundColor: Colors.white, color: Colors.black),
                            })),
                      )),
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      showNewPost = true;
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
                              FlatButton(
                                  onPressed: () {
                                    print("report abuse");
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.do_not_disturb_alt,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 5), child: Text(AppLocalizations.of(context).translate("app_forum_topic_view_btn_report_abuse"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))
                                    ],
                                  )),
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
      showNewPost ? ForumNewPost(parentSize: size, newPostMode: NewPostMode.reply, topicInfo: widget.topic, onCloseBtnHandler: onNewPostCloseHandler) : Container()
    ]);
  }
}

typedef OnReplyViewTap = void Function(int replyId);

class RepliesDataTableSource extends DataTableSource {
  RepliesDataTableSource({@required this.topicId, @required this.replies, @required this.onReplyViewTap});

  final int topicId;
  final List<ForumReplyModel> replies;
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
    print("reply #" + index.toString());
    if (index >= replies.length) {
      return null;
    }

    final reply = replies[index];
    final UserInfo userInfo = DataMocker.users.where((user) => user.userId == reply.ownerId).first;

    List<DataCell> cells = new List<DataCell>();

    cells.add(new DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [getRowIndexRenderer(index), ForumUserRenderer(userInfo: userInfo), Expanded(child: Container()), getOpenReplyButton(replies[index].id)],
    )));

    DataRow row = new DataRow(cells: cells);

    return row;
  }
}
