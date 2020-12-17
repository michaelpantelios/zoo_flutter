import 'package:flutter/material.dart';

class ForumReplyRecordModel {
  final dynamic id;
  final dynamic parent;
  final dynamic from;
  final dynamic date;
  final dynamic read;

  ForumReplyRecordModel({
    @required this.id,
    @required this.parent,
    @required this.from,
    @required this.date,
    @required this.read
});

  factory ForumReplyRecordModel.fromJSON(data){
    return ForumReplyRecordModel(
        id: data["id"],
        parent: data["parent"],
        from: data["from"],
        date: data["date"],
        read: data["read"]
    );
  }


}