
enum Tier { silver, gold, platinum, }

class Member {
  final String? name;
  final String email;
  final String? password;
  final String? position;
  final Tier? tier;

  Member({
    this.name,
    required this.email,
    this.password,
    this.position,
    this.tier,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
    name: json['name'],
    email: json['email'],
    position: json['position'],
    tier: _tierFromString(json['tier']),
    );
  }

  static Tier? _tierFromString(String tierString) {
    switch (tierString) {
      case 'SILVER':
        return Tier.silver;
      case 'GOLD':
        return Tier.gold;
      case 'PLATINUM':
        return Tier.platinum;
      default:
        return null;
    }
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
