class UserProfile {
  final String username;
  final String email;
  final double xp;
  final int coins;
  final int hp;

  UserProfile({
    required this.username,
    required this.email,
    required this.xp,
    required this.coins,
    required this.hp,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
        username: json['username'] as String,
        email: json['email'] as String,
        xp: json['xp'] as double,
        coins: json['coins'] as int,
        hp: json['hp'] as int);
  }
}
