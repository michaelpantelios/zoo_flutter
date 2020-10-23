import 'package:flutter/material.dart';

class ForumTopic {
  final int id;
  final int ownerId;
  final int categoryId;
  final String title;
  final DateTime date;
  final String text;
  final int views;

  ForumTopic({
    @required this.id,
    @required this.ownerId,
    @required this.categoryId,
    @required this.title,
    @required this.date,
    @required this.text,
    @required this.views
});

}