import 'package:zoo_flutter/models/user/user_info.dart';

class MailMessageInfo {
  final int id;
  final UserInfo from;
  final UserInfo to;
  final dynamic date;
  final int read;
  final int replied;
  final String type;
  final String subject;
  final dynamic body;
  final List<dynamic> attachments;

  MailMessageInfo({this.id, this.date, this.type, this.subject, this.attachments, this.body, this.replied, this.read, this.from, this.to});

  factory MailMessageInfo.fromJSON(data) {
    return MailMessageInfo(
      id: data["id"],
      from: data["from"] != null ? UserInfo.fromJSON(data["from"]) : null,
      to: data["to"] != null ? UserInfo.fromJSON(data["to"]) : null,
      date: data["date"],
      type: data["type"],
      subject: data["subject"],
      body: data["body"],
      attachments: data["attachments"],
      read: data["read"],
      replied: data["replied"],
    );
  }
}
