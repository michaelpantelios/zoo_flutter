class UserGiftInfo{
  final dynamic id;
  final dynamic fromUser;
  final dynamic msg;
  final dynamic giftId;
  final dynamic giftName;
  final dynamic giftURL;

  UserGiftInfo({ this.id, this.fromUser, this.msg, this.giftId, this.giftName, this.giftURL});

  factory UserGiftInfo.fromJSON(data) {
    return UserGiftInfo(
      id: data["id"],
      fromUser: data["fromUser"],
      msg: data["msg"],
      giftId: data["giftId"],
      giftName: data["giftName"],
      giftURL: data["giftURL"],
    );
  }
}