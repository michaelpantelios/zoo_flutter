import 'package:zoo_flutter/models/user/user_info.dart';

class MailInfo {
  final int id;
  final dynamic date;
  final String type;
  final String subject;
  final int attachNo;
  final int read;
  final int replied;
  final UserInfo from;
  final UserInfo to;

  MailInfo({this.id, this.date, this.type, this.subject, this.attachNo, this.read, this.from, this.replied, this.to});

  factory MailInfo.fromJSON(data) {
    return MailInfo(
      id: data["id"],
      from: data["from"] != null ? UserInfo.fromJSON(data["from"]) : null,
      to: data["to"] != null ? UserInfo.fromJSON(data["to"]) : null,
      date: data["date"],
      type: data["type"],
      subject: data["subject"],
      attachNo: data["attachNo"],
      read: data["read"],
      replied: data["replied"],
    );
  }
}
