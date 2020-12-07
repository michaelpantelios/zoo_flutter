class UserInfo {
  final String username; //The username of the user
  final int userId; //User's id
  final dynamic birthday; //User's birthday
  final int country; //User's country
  final String zip; //User's postal code (only for greek users)
  final String city; //User's city (only for foreign users)
  final int star; //1- user is star member 0- otherwise
  final int sex; //1-man, 2-woman, 4-couple
  final int logins; //The number of times this user has logged in
  final dynamic lastLogin; //The exact date and time of his last login (obviously it will be the current datetime)
  final int userCode; //User's numeric code
  final int coins; //The number of user's coins
  final dynamic mainPhoto; //An object with info about his main photo
  final int fbUser; //0- zoo only account, 1- facebook-only account, without password, 2- linked zoo and facebook accounts
  final int unreadMail; //number of unread mail messages
  final int unreadAlerts; //number of unread alerts
  final int points; //user's weekly points
  final int level; //user's level
  final int levelPoints; //user's points for the next level
  final String levelTotal; //total number of points to reach the next level
  final Map<String, dynamic> settings; //an object with the following fields: favourites:  user-defined setting, background:  user-defined setting
  UserInfo({
    this.username,
    this.userId,
    this.birthday,
    this.country,
    this.zip,
    this.city,
    this.star,
    this.sex,
    this.logins,
    this.lastLogin,
    this.userCode,
    this.coins,
    this.mainPhoto,
    this.fbUser,
    this.unreadMail,
    this.unreadAlerts,
    this.points,
    this.level,
    this.levelPoints,
    this.levelTotal,
    this.settings,
  });

  get isStar => this.star == 1;

  factory UserInfo.fromJSON(data) {
    return UserInfo(
      username: data["username"],
      userId: data["userId"],
      birthday: data["birthday"],
      country: data["country"],
      zip: data["zip"],
      city: data["city"],
      star: data["star"],
      sex: data["sex"],
      logins: data["logins"],
      lastLogin: data["lastLogin"],
      userCode: data["userCode"],
      coins: data["coins"],
      mainPhoto: data["mainPhoto"],
      fbUser: data["fbUser"],
      unreadMail: data["unreadMail"],
      unreadAlerts: data["unreadAlerts"],
      points: data["points"],
      level: data["level"],
      levelPoints: data["levelPoints"],
      levelTotal: data["levelTotal"],
      settings: data["settings"],
    );
  }
}
