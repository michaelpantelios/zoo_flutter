// username:   User's username
// sex:        User's sex
// userId:     User's user code
// star:       1- if he is a star member  0- otherwise
// mainPhoto:  An object with info about the user's main photo
// id:       Photo's id
// image_id: The id of the corresponding image
// width:    Photo's width
// height:   Photo's height

class ManiacUserRecord{
  final String username;
  final dynamic sex;
  final dynamic userId;
  final dynamic star;
  final dynamic mainPhoto;

  ManiacUserRecord({this.username, this.sex, this.userId, this.star, this.mainPhoto});

  factory ManiacUserRecord.fromJSON(data) {
    return ManiacUserRecord(
      username: data["username"],
      sex: data["sex"],
      userId: data["userId"],
      star: data["star"],
      mainPhoto: data["mainPhoto"]
    );
  }
}