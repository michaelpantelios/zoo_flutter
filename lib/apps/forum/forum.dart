import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/forum/forum_new_post.dart';
import 'package:zoo_flutter/apps/forum/forum_topic_view.dart';
import 'package:zoo_flutter/apps/forum/forum_user_renderer.dart';
import 'package:zoo_flutter/apps/forum/models/forum_topic_model.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/data_mocker.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

enum ViewStatus { homeView, topicView }

class Forum extends StatefulWidget {
  Forum({Key key});

  ForumState createState() => ForumState();
}

class ForumState extends State<Forum> with SingleTickerProviderStateMixin {
  ForumState();

  RPC _rpc;
  GlobalKey _key = GlobalKey();
  Size size;
  Offset position;
  TabController _tabController;
  int _selectedTabIndex = 0;
  ViewStatus _viewStatus = ViewStatus.homeView;
  ForumTopicModel _selectedTopic;
  List<ForumTopicModel> _topics;
  bool showNewPost = false;

  double _tableHeight;
  double _tableRowHeight = 50;

  int _searchByValue = 1;

  onNewPostCloseHandler() {
    setState(() {
      showNewPost = false;
    });
  }

  _afterLayout(_) {
    final RenderBox renderBox = _key.currentContext.findRenderObject();

    size = renderBox.size;
    position = renderBox.localToGlobal(Offset.zero);
    //
    // print("SIZE : $size");
    // print("POSITION : $position");
  }

  @override
  void initState() {
    print("forum initState");
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    _rpc = RPC();

    _tabController = TabController(length: DataMocker.forumCategories.length, vsync: this);
    _selectedTabIndex = 0;
    _topics = DataMocker.instance.getManyTopics().where((topic) => topic.categoryId == _selectedTabIndex).toList();

    _tabController.addListener(() {
      setState(() {
        print("Selected Index: " + _tabController.index.toString());
        _selectedTabIndex = _tabController.index;
        _topics = DataMocker.instance.getManyTopics().where((topic) => topic.categoryId == _selectedTabIndex).toList();
      });
    });

    super.initState();

  }

  getForumList() async {
    var res = await _rpc.callMethod("OldApps.Forum.getForumList", []);

    if (res["status"] == "ok") {
      print("forumList: ");
      print(res["data"]);
    } else {
      print("ERROR");
      print(res["status"]);
    }
    return res;

  }

  onTopicTitleTap(int topicId) {
    print("clicked on topic: " + topicId.toString());
    setState(() {
      _selectedTopic = DataMocker.instance.getManyTopics().where((topic) => topic.id == topicId).first;
      _viewStatus = ViewStatus.topicView;
    });
  }

  onTopicOwnerTap(UserInfo userInfo) {
    print("clicked on user: " + userInfo.userId.toString());
  }

  onReturnToForumView() {
    setState(() {
      _viewStatus = ViewStatus.homeView;
    });
  }

  @override
  Widget build(BuildContext context) {
    _tableHeight = MediaQuery.of(context).size.height - 120;

    final _dtSource = TopicsDataTableSource(topics: _topics, context: context, onTopicTap: (topicId) => onTopicTitleTap(topicId), onTopicOwnerTap: (userInfo) => onTopicOwnerTap(userInfo));

    getTabs() {
      List<Widget> _tabs = new List<Widget>();
      DataMocker.forumCategories.forEach((category) => _tabs.add(new Container(
            width: 120,
            padding: EdgeInsets.all(3),
            child: Text(category.name, style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.center),
          )));
      return _tabs;
    }

    getTableViewActions() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButton(
              value: _searchByValue,
              items: [
                DropdownMenuItem(
                  child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_0"), style: Theme.of(context).textTheme.bodyText1),
                  value: 0,
                ),
                DropdownMenuItem(
                  child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_1"), style: Theme.of(context).textTheme.bodyText1),
                  value: 1,
                ),
                DropdownMenuItem(child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_2"), style: Theme.of(context).textTheme.bodyText1), value: 2),
                DropdownMenuItem(child: Text(AppLocalizations.of(context).translate("app_forum_dropdown_value_3"), style: Theme.of(context).textTheme.bodyText1), value: 3)
              ],
              onChanged: (value) {
                setState(() {
                  _searchByValue = value;
                  print("sort by " + _searchByValue.toString());
                });
              }),
          FlatButton(
            onPressed: () {
              print("refresh");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(Icons.refresh, color: Colors.blue, size: 20), Padding(padding: EdgeInsets.all(3), child: Text(AppLocalizations.of(context).translate("app_forum_btn_refresh"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))],
            ),
          ),
          FlatButton(
            onPressed: () {
              print("new topic");
              setState(() {
                showNewPost = true;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(Icons.add_circle, color: Colors.yellow[700], size: 20), Padding(padding: EdgeInsets.all(3), child: Text(AppLocalizations.of(context).translate("app_forum_new_topic"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))],
            ),
          ),
          FlatButton(
            onPressed: () {
              print("search topic");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(Icons.search, color: Colors.green, size: 20), Padding(padding: EdgeInsets.all(3), child: Text(AppLocalizations.of(context).translate("app_forum_btn_search"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)))],
            ),
          )
        ],
      );
    }

    getTableView() {
      return PaginatedDataTable(columns: [
        DataColumn(
          label: Text(AppLocalizations.of(context).translate("app_forum_column_from"), style: Theme.of(context).textTheme.bodyText1),
        ),
        DataColumn(
          label: Text(AppLocalizations.of(context).translate("app_forum_column_title"), style: Theme.of(context).textTheme.bodyText1),
        ),
        DataColumn(
          label: Text(AppLocalizations.of(context).translate("app_forum_column_date"), style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center),
        ),
        DataColumn(
          label: Text(AppLocalizations.of(context).translate("app_forum_column_replies"), style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center),
        ),
      ], rowsPerPage: ((_tableHeight - 140) / _tableRowHeight).floor(), source: _dtSource, header: getTableViewActions()
          // actions: getTableViewActions()

          );
    }

    getCategoryName(int categoryId) {
      return DataMocker.forumCategories.where((category) => category.id == categoryId).first.name;
    }

    return Stack(
      key: _key,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.all(5),
                child: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    // labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(color: Color(0xFF222222), width: 2.0),
                      insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    ),
                    unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xffA7A7A7)),
                    tabs: getTabs())),
            SizedBox(
                width: double.infinity,
                height: _tableHeight,
                child: _viewStatus == ViewStatus.topicView && _selectedTopic != null
                    ? ForumTopicView(
                        topic: _selectedTopic,
                        onReturnToForumView: onReturnToForumView,
                      )
                    : getTableView())
          ],
        ),
        Center(
          child: ZButton(
            label: "Fere to forum",
            buttonColor: Colors.green,
            clickHandler: (){
              if (!UserProvider.instance.logged) {
                print("Forum: not logged");
                // widget.onClose(
                //     PopupManager.instance.show(
                //     context: context,
                //     popup: PopupType.Login,
                //     callbackAction: (retValue) {
                //       print(retValue);
                //     },
                //   )
                // );
                //
              } else {
                var res = getForumList();
              }
            },
          )
        )
        // showNewPost ? ForumNewPost(parentSize: size, newPostMode: NewPostMode.newTopic, categoryName: getCategoryName(_selectedTabIndex), onCloseBtnHandler: onNewPostCloseHandler) : Container()
      ],
    );
  }
}

typedef OnTopicTap = void Function(int topicId);
typedef OnTopicOwnerTap = void Function(UserInfo userInfo);

class TopicsDataTableSource extends DataTableSource {
  TopicsDataTableSource({@required this.topics, @required this.context, @required this.onTopicTap, @required this.onTopicOwnerTap}) : assert(topics != null);

  final BuildContext context;
  final List<ForumTopicModel> topics;
  final OnTopicTap onTopicTap;
  final OnTopicOwnerTap onTopicOwnerTap;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => topics.length;

  @override
  int get selectedRowCount => 0;

  getTopicsListTitleRenderer(String title, int topicId) {
    return GestureDetector(
        onTap: () {
          onTopicTap(topicId);
        },
        child: Text(title, style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.start));
  }

  getTopicDateRenderer(DateTime date) {
    return Text(date.toString(), style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center);
  }

  getRepliesRenderer(int num) {
    return Text(num.toString(), style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center);
  }

  @override
  DataRow getRow(int index) {
    // assert(index >= 0);

    if (index >= topics.length) {
      return null;
    }

    final topic = topics[index];

    List<DataCell> cells = new List<DataCell>();
    UserInfo userInfo = DataMocker.users.where((user) => user.userId == topic.ownerId).first;
    cells.add(new DataCell(ForumUserRenderer(userInfo: userInfo)));

    cells.add(new DataCell(getTopicsListTitleRenderer(topic.title, topic.id)));

    cells.add(new DataCell(getTopicDateRenderer(topic.date)));

    int repliesNum = DataMocker.forumReplies.where((reply) => reply.topicId == topic.id).length;
    cells.add(new DataCell(getRepliesRenderer(repliesNum)));

    DataRow row = new DataRow(cells: cells);

    return row;
  }
}
