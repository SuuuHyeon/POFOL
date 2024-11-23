
enum Tier { silver, gold, platinum, }

class Member {
  final String name;
  final String email;
  final String password;
  final String position;
  final Tier? tier;

  Member({
    required this.name,
    required this.email,
    required this.password,
    required this.position,
    this.tier,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      position: json['position'],
      tier: json['tier'] != null ? Tier.values[json['tier']] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'position': position,
    };
  }
}
