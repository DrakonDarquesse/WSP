class Member {
  String email;
  String password;
  String name;
  bool isActive;

  Member(
      {required this.email,
      required this.password,
      required this.name,
      this.isActive = true});
}
