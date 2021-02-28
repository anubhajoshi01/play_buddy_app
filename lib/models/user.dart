${this.widget.post.usersSignedUp.length} / ),class User {
  int id;
  String email;
  Set<int> friendsUserIdList;
  Set<int> postIdList;
  Set<int> requestSentList;
  Set<int> requestReceivedList;
  Set<int> postsSignedUpFor;
  String name;
  String bio;

  User(this.id, this.email, this.friendsUserIdList, this.postIdList,
      this.requestSentList, this.requestReceivedList, this.postsSignedUpFor, this.name, this.bio);
}
