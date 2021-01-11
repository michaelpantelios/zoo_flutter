import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zoo_flutter/apps/forum/models/forum_topic_record_model.dart';
import 'package:zoo_flutter/apps/home/modules/module_header.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/app_provider.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';

class HomeModuleForumHot extends StatefulWidget {
  HomeModuleForumHot();

  HomeModuleForumHotState createState() => HomeModuleForumHotState();
}

class HomeModuleForumHotState extends State<HomeModuleForumHot> {
  HomeModuleForumHotState();

  RPC _rpc;
  List<Widget> _hotTopicsItems = new List<Widget>();

  @override
  void initState() {
    _rpc = RPC();

    super.initState();
    UserProvider.instance.addListener(onUserProviderSessionKey);
  }

  onUserProviderSessionKey() {
    UserProvider.instance.removeListener(onUserProviderSessionKey);
    if (UserProvider.instance.sessionKey != null) getHotTopics();
  }

  _openProfile(BuildContext context, int userId) {
    print("_openProfile " + userId.toString());
    if (!UserProvider.instance.logged) {
      PopupManager.instance.show(
          context: context,
          popup: PopupType.Login,
          callbackAction: (res) {
            if (res) {
              print("ok");
              _doOpenProfile(context, userId);
            }
          });
      return;
    }
    _doOpenProfile(context, userId);
  }

  _doOpenProfile(BuildContext context, int userId) {
    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userId, callbackAction: (retValue) {});
  }

  _onOpenTopic(ForumTopicRecordModel info) {
    // AppProvider.instance.currentAppInfo.options = {"topicId": info.id, "forumId" : info.forumId};
    context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.Forum).id, context, {"topicId": info.id, "forumId": info.forumId});
  }

  getHotTopics() async {
    var _criteria = {"forumId": "1"};
    var _options = {"page": 1, "recsPerPage": 30, "order": "date"};

    var res = await _rpc.callMethod("OldApps.Forum.getTopicList", _criteria, _options);

    if (res["status"] == "ok") {
      List<ForumTopicRecordModel> _topics = new List<ForumTopicRecordModel>();
      List<Widget> lst = [];
      for (int i = 0; i < res["data"]["records"].length; i++) {
        _topics.add(ForumTopicRecordModel.fromJSON(res["data"]["records"][i]));
      }

      _topics.sort((b, a) => int.parse(a.repliesNo.toString()).compareTo(int.parse(b.repliesNo.toString())));

      for (int j = 0; j < 3; j++) {
        if (j <= _topics.length - 1) lst.add(getTopicItem(_topics[j], j));
      }

      setState(() {
        _hotTopicsItems = lst;
      });
    } else {
      print("error");
      print(res["status"]);
    }
  }

  getTopicItem(ForumTopicRecordModel info, int index) {
    return Column(
      children: [
        Row(
          children: [
            Text(AppLocalizations.of(context).translate("app_home_module_forum_hot_subject"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left),
            SizedBox(width: 3),
            Flexible(
                child: FlatButton(
                    height: 15,
                    onPressed: () {
                      _onOpenTopic(info);
                    },
                    child: Text(info.subject, style: Theme.of(context).textTheme.bodyText2, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis)))
          ],
        ),
        Row(
          children: [
            Text(AppLocalizations.of(context).translate("app_home_module_forum_hot_from"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left),
            SizedBox(width: 3),
            Flexible(
                child: FlatButton(
                    height: 15,
                    onPressed: () {
                      _openProfile(context, info.from["userId"]);
                    },
                    child: Text(info.from["username"], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.left)))
          ],
        ),
        Row(
          children: [
            Text(AppLocalizations.of(context).translate("app_home_module_forum_hot_date"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left),
            SizedBox(width: 3),
            Text(Utils.instance.getNiceForumDate(dd: info.date), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.left)
          ],
        ),
        Row(
          children: [
            Text(AppLocalizations.of(context).translate("app_home_module_forum_hot_replies"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.left),
            SizedBox(width: 3),
            Text(info.repliesNo.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.left)
          ],
        ),
        if (index < 2) Padding(padding: EdgeInsets.symmetric(vertical: 3), child: Divider(height: 1, color: Color(0xffD2D2D2))) else Container()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          // border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getModuleHeader(AppLocalizations.of(context).translate("app_home_module_title_forum_hot"), context),
            Container(
                padding: EdgeInsets.all(7),
                child: Column(
                  children: _hotTopicsItems,
                )),
            Container(
                padding: EdgeInsets.only(right: 7),
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    height: 14,
                    onPressed: () {
                      context.read<AppProvider>().activate(AppProvider.instance.getAppInfo(AppType.Forum).id, context);
                    },
                    child: Text(AppLocalizations.of(context).translate("app_home_more_link"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold))))
          ],
        ));
  }
}
