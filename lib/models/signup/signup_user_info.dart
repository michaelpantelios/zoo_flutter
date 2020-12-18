import 'package:flutter/foundation.dart';

class SignUpUserInfo {
  final String username; //The username of the new user
  final String password; //The password of the new user
  final String email; //User's email
  final int country; //User's country
  final String zip; //User's postal code (only for greek users)
  final String city; //User's city (only for foreign users)
  final String birthday; //Exact date of birth (yyyy/mm/dd)
  final int sex; //1-male, 2-female, 4-couple
  final int newsletter; //1- the user wants to receive newsletters  0- otherwise
  final int facebook; //1- create a facebook-only account
  final int importFbPhoto; //1- import facebook profile photo in zoo profile
  SignUpUserInfo({
    @required this.username,
    @required this.password,
    @required this.email,
    @required this.country,
    @required this.zip,
    @required this.city,
    @required this.birthday,
    @required this.sex,
    this.newsletter = 1,
    this.facebook = 0,
    this.importFbPhoto = 0,
  });

  Map<String, dynamic> toJson() => {
        'username': this.username,
        'password': this.password,
        'email': this.email,
        'country': this.country,
        'zip': this.zip,
        'city': this.city,
        'birthday': this.birthday,
        'sex': this.sex,
        'newsletter': this.newsletter,
        'facebook': this.facebook,
        'importFbPhoto': this.importFbPhoto,
      };
}
