// 토큰 모델
class JwtResponseModel {
  final String accessToken;
  final String refreshToken;

  JwtResponseModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory JwtResponseModel.fromJson(Map<String, dynamic> json) {
    return JwtResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}