// level:      The user's level
// user:       An object of the following form:
// username:   User's username
// sex:        User's sex
// userId:     User's user code
// star:       1- if he is a star member  0- otherwise
// mainPhoto:  An object with info about the user's main photo
// id:       Photo's id
// image_id: The id of the corresponding image
// width:    Photo's width
// height:   Photo's height

import 'package:zoo_flutter/models/maniacs/maniac_user_record.dart';

class LevelManiacRecord{
  dynamic level;
  ManiacUserRecord user;

  LevelManiacRecord({this.level, this.user});

  factory LevelManiacRecord.fromJSON(data) {
    return LevelManiacRecord(
        level: data["level"],
        user: ManiacUserRecord.fromJSON(data["user"])
    );
  }
}