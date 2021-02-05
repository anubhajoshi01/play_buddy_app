class User {
  int id;
  String email;
  Set<int> friendsUserIdList;
  Set<int> postIdList;
  String name;
  String bio;

  User(this.id, this.email, this.friendsUserIdList, this.postIdList, this.name,
      this.bio);
}
