class User {
  int id;
  String email;
  Set<int> friendsUserIdList;
  Set<int> postIdList;
  Set<int> requestSentList;
  Set<int> requestReceivedList;
  String name;
  String bio;

  User(this.id, this.email, this.friendsUserIdList, this.postIdList,
      this.requestSentList, this.requestReceivedList, this.name, this.bio);
}
