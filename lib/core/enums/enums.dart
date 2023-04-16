enum ThemeMode { light, dark }

enum UserKarma {
  comment(karma: 1),
  textPost(karma: 2),
  linkPost(karma: 3),
  imagePost(karma: 3),
  awardPost(karma: 5),
  deletePost(karma: -1);

  final int karma;
  const UserKarma({required this.karma});
}

enum UserAwards {
  awesomeAns("awesomeAns"),
  gold("gold"),
  platinum("platinum"),
  helpful("helpful"),
  plusone("plusone"),
  rocket("rocket"),
  thankyou("thankyou"),
  til("til");
  final String awards;
  const UserAwards(this.awards);
}
