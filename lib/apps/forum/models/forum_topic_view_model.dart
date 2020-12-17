import 'package:zoo_flutter/apps/forum/models/forum_user_model.dart';

class ForumTopicViewModel {
  final dynamic id;
  final dynamic forumId;
  final dynamic from;
  final String date;
  final dynamic approved;
  final dynamic sticky;
  final dynamic locked;
  final dynamic views;
  final String subject;
  final String body;

  ForumTopicViewModel({
    this.id,
    this.forumId,
    this.from,
    this.date,
    this.approved,
    this.sticky,
    this.locked,
    this.views,
    this.subject,
    this.body
  });

  factory ForumTopicViewModel.fromJSON(data){
    return ForumTopicViewModel(
        id: data["id"],
        forumId: data["forumId"],
        from: data["from"],
        date: data["date"],
        approved: data["approved"],
        sticky: data["sticky"],
        locked: data["locked"],
        views: data["views"],
        subject: data["subject"],
        body: data["body"]
    );
  }

}