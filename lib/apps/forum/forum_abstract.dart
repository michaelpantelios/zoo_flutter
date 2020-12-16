import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/apps/forum/forum_new_post.dart';
import 'package:zoo_flutter/apps/forum/forum_topic_view.dart';
import 'package:zoo_flutter/apps/forum/forum_user_renderer.dart';
import 'package:zoo_flutter/apps/forum/models/forum_topic_model.dart';
import 'package:zoo_flutter/models/user/user_info.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class ForumAbstract extends StatefulWidget {
  ForumAbstract({Key key, this.forumId, this.autoLoad = false, this.myHeight }) : super(key: key);

  final dynamic forumId;
  final bool autoLoad;
  final double myHeight;

  ForumAbstractState createState() => ForumAbstractState(key : key);
}

class ForumAbstractState extends State<ForumAbstract>{
  ForumAbstractState({Key key});

  RPC _rpc;

  start(){
    print("start for "+widget.forumId.toString()+ ": ");
    getTopicList();
  }

  @override
  void initState() {
    _rpc = RPC();

    if (widget.autoLoad) start();

    super.initState();
  }
  
  getTopicList() async {
    print("topicList for "+widget.forumId.toString()+ ": ");
    var res = await _rpc.callMethod("OldApps.Forum.getTopicList", {"forumId":widget.forumId});

    if (res["status"] == "ok"){

      // print(res["data"]);
    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
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
    // UserInfo userInfo = DataMocker.users.where((user) => user.userId == topic.ownerId).first;
    // cells.add(new DataCell(ForumUserRenderer(userInfo: userInfo)));

    cells.add(new DataCell(getTopicsListTitleRenderer(topic.title, topic.id)));

    cells.add(new DataCell(getTopicDateRenderer(topic.date)));

    // int repliesNum = DataMocker.forumReplies.where((reply) => reply.topicId == topic.id).length;
    // cells.add(new DataCell(getRepliesRenderer(repliesNum)));

    DataRow row = new DataRow(cells: cells);

    return row;
  }
}
