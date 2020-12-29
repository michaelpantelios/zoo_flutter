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

class ProfileViewRecordUser {
  final String username;
  final dynamic sex;
  final dynamic star;
  final dynamic haPhotos;
  final dynamic mainPhoto;

  ProfileViewRecordUser({this.username, this.sex, this.star, this.haPhotos, this.mainPhoto});

  factory ProfileViewRecordUser.fromJSON(data) {
    return ProfileViewRecordUser(
        username: data["username"],
        sex: data["sex"],
        star: data["star"],
        haPhotos: data["haPhotos"],
        mainPhoto: data["mainPhoto"]
    );
  }
}