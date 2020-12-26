class UserInfo {
  final String username; //The username of the user
  final dynamic userId; //User's id
  final dynamic birthday; //User's birthday
  final dynamic country; //User's country
  final String zip; //User's postal code (only for greek users)
  final String city; //User's city (only for foreign users)
  final dynamic star; //1- user is star member 0- otherwise
  final dynamic sex; //1-man, 2-woman, 4-couple
  final dynamic logins; //The number of times this user has logged in
  final dynamic lastLogin; //The exact date and time of his last login (obviously it will be the current datetime)
  final dynamic userCode; //User's numeric code
  final dynamic coins; //The number of user's coins
  final dynamic mainPhoto; //An object with info about his main photo
  final dynamic fbUser; //0- zoo only account, 1- facebook-only account, without password, 2- linked zoo and facebook accounts
  final dynamic unreadMail; //number of unread mail messages
  final dynamic unreadAlerts; //number of unread alerts
  final dynamic points; //user's weekly points
  final dynamic level; //user's level
  final dynamic levelPoints; //user's points for the next level
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

  bool _activated;

  set activated(value) {
    _activated = value;
  }

  get activated => _activated;

  String _code = null;
  set code(value) {
    _code = value;
  }

  get code => _code;

  bool _isChatMaster = false;
  set isChatMaster(value) {
    _isChatMaster = value;
  }

  get isChatMaster => _isChatMaster;

  bool _isOper = false;
  set isOper(value) {
    _isOper = value;
  }

  get isOper => _isOper;

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
