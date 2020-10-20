import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

import 'package:zoo_flutter/utils/data_mocker.dart';

import 'package:zoo_flutter/models/forum/forum_topic.dart';
import 'package:zoo_flutter/models/forum/forum_reply.dart';

enum ViewStatus {homeView, postView}

class Forum extends StatefulWidget {
  Forum({Key key});

  ForumState createState() => ForumState();
}

class ForumState extends State<Forum> with SingleTickerProviderStateMixin{
  ForumState();

  TabController _tabController;
  int _selectedTabIndex = 0;
  ViewStatus _viewStatus = ViewStatus.homeView;
  int _selectedPostId = -1;
  List<ForumTopic> _topics;



  @override
  void initState() {
    _tabController = TabController(length: DataMocker.forumCategories.length, vsync: this);
    _selectedTabIndex = 0;
    _topics = DataMocker.forumTopics.where((topic) => topic.categoryId == _selectedTabIndex).toList();


    _tabController.addListener(() {
      setState(() {
        print("Selected Index: " + _tabController.index.toString());
        _selectedTabIndex = _tabController.index;
        _topics = DataMocker.forumTopics.where((topic) => topic.categoryId == _selectedTabIndex).toList();
         getForumHomeView();
      });
    });

    super.initState();
  }

  getForumHomeView(){
    List<DataRow> _rows = new List<DataRow>();
    for(int i=0; i<_topics.length; i++){
      ForumTopic topic = _topics[i];
      List<DataCell> cells = new List<DataCell>();
      cells.add(new DataCell(Text(topic.ownerId.toString(), style: Theme.of(context).textTheme.bodyText1)));
      cells.add(new DataCell(Text(topic.title, style: Theme.of(context).textTheme.bodyText1)));
      cells.add(new DataCell(Text(topic.date.toString(), style: Theme.of(context).textTheme.bodyText1)));
      cells.add(new DataCell(Text("33", style: Theme.of(context).textTheme.bodyText1)));
      DataRow row = new DataRow(cells: cells);

      _rows.add(row);
    }

    return SizedBox(
        width: double.infinity,
        child: DataTable(
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
                style: Theme.of(context).textTheme.bodyText1
            ),
          ),
          DataColumn(
            label: Text(
                AppLocalizations.of(context).translate("app_forum_column_replies"),
                style: Theme.of(context).textTheme.bodyText1
            ),
          ),
        ],
        rows: _rows
    ));
  }

  getPostView(int postId){
    return postId == -1 ? Container(color: Colors.blue) : Container(color: Colors.green);
  }

  @override
  Widget build(BuildContext context) {

    getTabs(){
      List<Widget> _tabs = new List<Widget>();
      DataMocker.forumCategories.forEach((category) =>
          _tabs.add(
              new Container(
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

    return Expanded(
      child: Container(
          color: Theme.of(context).canvasColor,
          child: Column(
            children: [
              TabBar(
                  controller: _tabController,
                  labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
                   indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Color(0xFF222222), width: 2.0),
                    insets: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  ),
                  unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xffA7A7A7)),
                  tabs: getTabs()
              ),
              _viewStatus == ViewStatus.homeView ? getForumHomeView() : getPostView(_selectedPostId)
            ],
          )
      )
    );

  }
}
