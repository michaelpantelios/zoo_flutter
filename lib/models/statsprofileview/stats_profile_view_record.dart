// user:   An object of the following form:
// username:   Viewer's username
// sex:        Viewer's sex
// star:       1- if he is star member  0- otherwise
// hasPhotos:  1- if he has photos  0- otherwise
// mainPhoto:  An object with info about viewer's main photo
// id:        Photo's id
// image_id:  The id of the corresponding image
// width:     Photo's width
// height:    Photo's height
// or undefined if viewer has no main photo
// times:  The number of views by this user at the specified date
// last:   The date and time of the last view

import 'package:zoo_flutter/models/statsprofileview/stats_profile_view_record_user.dart';

class StatsProfileViewRecord{
  final StatsProfileViewRecordUser user;
  final dynamic times;
  final dynamic last;

  StatsProfileViewRecord({this.user, this.times, this.last});

  factory StatsProfileViewRecord.fromJSON(data) {
    return StatsProfileViewRecord(
        user: StatsProfileViewRecordUser.fromJSON(data["user"]),
        times: data["times"],
        last: data["last"]
    );
  }
}
