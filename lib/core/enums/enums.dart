enum ThemeMode{
  ligth,
  dark
}

enum UserKarma{
comment(1),
  textPost(2),
  linkPost(3),
  imagePost(4),
  awardPost(5),
  deletePost(-1);

  final int karma;
const UserKarma(this.karma);
}