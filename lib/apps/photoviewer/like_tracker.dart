class LikeTracker {
  LikeTracker();

   static var likes = {};

  like(int id, bool value, int count) {
    LikeTracker.likes[id] = {value: value, count: count};
  }

  getLike(int id) {
    return LikeTracker.likes[id] != null ? LikeTracker.likes[id] : null;
  }
}