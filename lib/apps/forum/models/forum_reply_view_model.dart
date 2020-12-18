import 'package:zoo_flutter/apps/forum/models/forum_user_model.dart';

class ForumReplyViewModel {
  final dynamic id;
  final dynamic parent;
  final dynamic from;
  final String date;
  final dynamic approved;
  final dynamic views;
  final dynamic subject;
  final dynamic body;

  ForumReplyViewModel({
    this.id,
    this.parent,
    this.from,
    this.date,
    this.approved,
    this.views,
    this.subject,
    this.body
  });

  factory ForumReplyViewModel.fromJSON(data){
    return ForumReplyViewModel(
        id: data["id"],
        parent: data["parent"],
        from: data["from"],
        date: data["date"],
        approved: data["approved"],
        views: data["views"],
        subject: data["subject"],
        body: data["body"]
    );
  }

}