import 'package:flutter/material.dart';

class ForumReply {
  final int topicId;
  final int id;
  final int ownerId;
  final DateTime date;
  final String text;
  final int views;

  ForumReply({
    @required this.topicId,
    @required this.id,
    @required this.ownerId,
    @required this.date,
    @required this.text,
    @required this.views
});
}