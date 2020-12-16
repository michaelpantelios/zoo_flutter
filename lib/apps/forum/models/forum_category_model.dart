import 'package:flutter/material.dart';

class ForumCategoryModel {
  final dynamic id;
  final String code;

  ForumCategoryModel({
    @required this.id,
    @required this.code
  });

  factory ForumCategoryModel.fromJSON(data) {
    return ForumCategoryModel(
      id: data["id"],
      code: data["code"]
    );
  }
}