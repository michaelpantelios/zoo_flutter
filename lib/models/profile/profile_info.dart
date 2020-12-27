import 'package:zoo_flutter/models/user/user_info.dart';

class CounterInfo {
  final int photos;
  final int videos;
  final int trophies;
  final int friends;
  final int gifts;

  CounterInfo({
    this.photos,
    this.videos,
    this.trophies,
    this.friends,
    this.gifts,
  });

  factory CounterInfo.fromJSON(data) {
    return CounterInfo(
      photos: data["photos"],
      videos: data["videos"],
      trophies: data["trophies"],
      friends: data["friends"],
      gifts: data["gifts"],
    );
  }
}

class ProfileInfo {
  final String status;
  final UserInfo user;
  final dynamic age;
  final dynamic country;
  final dynamic city;
  final dynamic zodiacSign;
  final dynamic online;
  final dynamic createDate;
  final dynamic lastLogin;
  final dynamic onlineTime;
  final dynamic level;
  final dynamic zip;
  final String birthday;
  final CounterInfo counters;
  ProfileInfo({this.status, this.user, this.age, this.country, this.city, this.zodiacSign, this.online, this.createDate, this.lastLogin, this.onlineTime, this.level, this.zip, this.birthday, this.counters});

  factory ProfileInfo.fromJSON(data) {
    return ProfileInfo(
      status: data["status"],
      user: UserInfo.fromJSON(data["user"]),
      age: data["age"],
      country: data["country"],
      city: data["city"],
      zodiacSign: data["zodiacSign"],
      online: data["online"],
      createDate: data["createDate"],
      lastLogin: data["lastLogin"],
      onlineTime: data["onlineTime"],
      level: data["level"],
      zip: data["zip"],
      birthday: data["birthday"],
      counters: CounterInfo.fromJSON(data["counters"]),
    );
  }

  get isOnline => this.online == 1;
}
