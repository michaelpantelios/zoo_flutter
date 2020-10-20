import 'package:flutter/material.dart';

class ForumReply {
  final int postId;
  final int id;
  final int ownerId;
  final DateTime date;
  final String text;

  ForumReply({
    @required this.postId,
    @required this.id,
    @required this.ownerId,
    @required this.date,
    @required this.text
});
}