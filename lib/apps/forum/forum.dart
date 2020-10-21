import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

import 'package:zoo_flutter/utils/data_mocker.dart';

import 'package:zoo_flutter/apps/forum/forum_topic_view.dart';
import 'package:zoo_flutter/models/forum/forum_topic.dart';
import 'package:zoo_flutter/models/forum/forum_reply.dart';
import 'package:zoo_flutter/models/user/user_info.dart';

enum ViewStatus {homeView, topicView}

class Forum extends StatefulWidget {
  Forum({Key key});

  ForumState createState() => ForumState();
}

class ForumState extends State<Forum> with SingleTickerProviderStateMixin{
  ForumState();

  TabController _tabController;
  int _selectedTabIndex = 0;
  ViewStatus _viewStatus = ViewStatus.homeView;
  ForumTopic _selectedTopic;
  List<ForumTopic> _topics;

  @override
  void initState() {
    _tabController = TabController(length: DataMocker.forumCategories.length, vsync: this);
    _selectedTabIndex = 0;
    _topics = DataMocker.instance.getManyTopics().where((topic) => topic.categoryId == _selectedTabIndex).toList();

    _tabController.addListener(() {
      setState(() {
        print("Selected Index: " + _tabController.index.toString());
        _selectedTabIndex = _tabController.index;
        _topics = DataMocker.instance.getManyTopics().where((topic) => topic.categoryId == _selectedTabIndex).toList();
         // getForumHomeView();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _dtSource = TopicsDataTableSource(
        topics: _topics,
        context: context,
        onTopicTap: () => {} ,
        onTopicOwnerTap: () => {}
    );

    getTabs(){
      List<Widget> _tabs = new List<Widget>();
      DataMocker.forumCategories.forEach((category) =>
          _tabs.add(
              new Container(
                  width: 120,
                  padding: EdgeInsets.all(3),
                  child: Text(
                      category.name,
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.center
                  ),
              )
          )
      );
      return _tabs;
    }

    return SizedBox(
        width: double.infinity,
        child: PaginatedDataTable(
          columns: [
            DataColumn(
              label: Text(
                  AppLocalizations.of(context).translate("app_forum_column_from"),
                  style: Theme.of(context).textTheme.bodyText1
              ),
            ),
            DataColumn(
              label: Text(
                  AppLocalizations.of(context).translate("app_forum_column_title"),
                  style: Theme.of(context).textTheme.bodyText1
              ),
            ),
            DataColumn(
              label: Text(
                  AppLocalizations.of(context).translate("app_forum_column_date"),
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center
              ),
            ),
            DataColumn(
              label: Text(
                  AppLocalizations.of(context).translate("app_forum_column_replies"),
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center
              ),
            ),
          ],
          source: _dtSource,
          header:
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
                TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    // labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(color: Color(0xFF222222), width: 2.0),
                      insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    ),
                    unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xffA7A7A7)),
                    tabs: getTabs()
                ),
          //     ],
          //   )
          // ,

        ));

  }
}

typedef OnTopicTap = void Function();
typedef OnTopicOwnerTap = void Function();

class TopicsDataTableSource extends DataTableSource {
  TopicsDataTableSource({
    @required this.topics,
    @required this.context,
    @required this.onTopicTap,
    @required this.onTopicOwnerTap

  }) :
        assert(topics != null);

  final BuildContext context;
  final List<ForumTopic> topics;
  final OnTopicTap onTopicTap;
  final OnTopicOwnerTap onTopicOwnerTap;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => topics.length;

  @override
  int get selectedRowCount => 0;

  getUserRenderer(UserInfo userInfo){
    return GestureDetector(
      onTap: (){
        print("clicked on "+userInfo.username);
      },
      child: Container(
          padding: EdgeInsets.only(top: 3, bottom: 3, right: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon( Icons.face, color: userInfo.sex == UserSex.Boy ? Colors.blue : Colors.pink, size: 30),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: Text(userInfo.username, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left)
              ),
              userInfo.photoUrl == null ? Container() : Icon(Icons.camera_alt, color: Colors.orange, size: 20)
            ],
          )
      ),
    );
  }

  getTopicsListTitleRenderer(String title, int topicId){
    return GestureDetector(
        onTap: () {
          // setState(() {
          //   // _selectedPostId = topicId;
          //   _viewStatus = ViewStatus.topicView;
          },
        child: Text(title, style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.start)
    );
  }

  getTopicDateRenderer(DateTime date){
    return Text(date.toString(), style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center);
  }

  getRepliesRenderer(int num){
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
    cells.add(new DataCell(getUserRenderer(userInfo)));

    cells.add(new DataCell(getTopicsListTitleRenderer(topic.title, topic.id)));

    cells.add(new DataCell(getTopicDateRenderer(topic.date)));

    int repliesNum = DataMocker.forumReplies.where((reply) => reply.postId == topic.id).length;
    cells.add(new DataCell(getRepliesRenderer(repliesNum)));

    DataRow row = new DataRow(cells: cells);

    return row;

  }
}
