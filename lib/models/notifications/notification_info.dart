class NotificationType {
  static const ON_UPDATE_COUNTERS = "updateCounters";

  static const ON_SUB_RENEWAL = "sub_renewal";
  static const ON_SUB_ENDED = "sub_ended";

  static const ON_SYSTEM_MESSAGE = "message";

  static const ON_NEW_MAIL = "new_mail";

  static const ON_COINS_CHANGED = "coins_changed";

  static const ON_NEW_GIFT = "new_gift";

  static const ON_MESSENGER_USER_ONLINE = "messenger_friend_online";
  static const ON_MESSENGER_USER_OFFLINE = "messenger_friend_offline";
  static const ON_MESSENGER_CHAT_MESSAGE = "messenger_chat_message";
  static const ON_MESSENGER_STATUS_UPDATE = "messenger_status_update";
  static const ON_MESSENGER_FRIEND_REQUEST = "messenger_friendship_request";

  static const ON_GAME_INVITATION = "games_invite";

  static const ON_NEW_POINTS = "points_won";
  static const ON_LOGIN = "login";

  static const ON_ALERT = "alerts_new";

  static const ON_JUKEBOX_CURR_NEXT_TRACK = "jukebox_curr_next_track";

  static const ON_WALLET_OFFER = "wallet_show_offer";
}

class NotificationInfo {
  final String name;
  final dynamic args;

  NotificationInfo(this.name, this.args);

  @override
  String toString() {
    return "name: $name, args: $args";
  }
}
