// points:     The user's points
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
// count:    The total number of records

import 'package:zoo_flutter/models/maniacs/maniac_user_record.dart';

class PointsManiacRecord{
  dynamic points;
  ManiacUserRecord user;

  PointsManiacRecord({this.points, this.user});

  factory PointsManiacRecord.fromJSON(data) {
    return PointsManiacRecord(
        points: data["points"],
        user: ManiacUserRecord.fromJSON(data["user"])
    );
  }
}