import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:suhyeon_portfolio/data/DioClient.dart';
import 'package:suhyeon_portfolio/data/model/member.dart';
import 'package:suhyeon_portfolio/data/repository/auth_repository.dart';
import 'package:suhyeon_portfolio/providers/secure_storage_provider.dart';

class AuthViewmodel extends StateNotifier<Member?> {
  final AuthRepository _authRepository;

  AuthViewmodel(this._authRepository) : super(null);

  /// 회원가입
  Future<bool> registerMember(
      String email, String password, String name, String position) async {
    try {
      return await _authRepository.register(
        email: email,
        password: password,
        name: name,
        position: position,
      );
    } catch (e) {
      print('가입실패(viewModel) $e');
      rethrow;
    }
  }

  /// 로그인
  Future<void> loginMember(String email, String password) async {
    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );
      if (response.accessToken.isNotEmpty) {
        print('accessToken: ${response.accessToken}');
        await _authRepository.updateToken(
          response.accessToken,
          response.refreshToken,
        );
        final member = await fetchUserData(response.accessToken);
        state = member;
        print('토큰 업데이트 완료, 유저 정보 조회 완료');
      } else {
        throw Exception('토큰 없음');
      }
    } catch (e) {
      // 에러 메시지를 받아 스낵바 표시
      rethrow;
    }
  }


  /// 유저 정보 조회
  Future<Member> fetchUserData(String accessToken) async {
    try {
      final response = await _authRepository.getUserInfo(accessToken);
      return response;
    } catch (e) {
      print('유저정보조회실패(viewModel) $e');
      rethrow;
    }
  }
}

final authProvider = StateNotifierProvider<AuthViewmodel, Member?>(
  (ref) => AuthViewmodel(ref.watch(authRepositoryProvider)),
);
