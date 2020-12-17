import 'package:zoo_flutter/apps/forum/models/forum_user_model.dart';

class ForumTopicRecordModel {
  final dynamic id;
  final String subject;
  final dynamic lastReplyRead;
  final dynamic sticky;
  final dynamic from;
  final dynamic forumId;
  final dynamic read;
  final String date;
  final dynamic repliesNo;

  ForumTopicRecordModel({
    this.id,
    this.subject,
    this.lastReplyRead,
    this.sticky,
    this.from,
    this.forumId,
    this.read,
    this.date,
    this.repliesNo
});

  factory ForumTopicRecordModel.fromJSON(data){
    return ForumTopicRecordModel(
        id: data["id"],
        subject: data["subject"],
        lastReplyRead: data["lastReplyRead"],
        sticky: data["sticky"],
        from: data["from"],
        forumId: data["forumId"],
        read: data["read"],
        date: data["date"],
        repliesNo: data["repliesNo"]
    );
  }

}