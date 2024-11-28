import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suhyeon_portfolio/data/DioClient.dart';
import 'package:suhyeon_portfolio/data/model/member.dart';
import 'package:suhyeon_portfolio/data/repository/auth_repository.dart';

class AuthViewmodel extends StateNotifier<Member?> {
  final AuthRepository repository;

  AuthViewmodel(this.repository) : super(null);

  /// 회원가입
  Future<bool> registerMember({
    required String email,
    required String password,
    required String name,
    required String position,
  }) async {
    try {
      return await repository.register(
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
  Future<bool> loginMember({
    required String email,
    required String password,
  }) async {
    try {
      final response = await repository.login(
        email: email,
        password: password,
      );
      state = response;
      return true;
    } catch (e) {
      print('로그인실패(viewModel) $e');
      rethrow;
    }
  }
}

final authRepositoryProvider =
    Provider((ref) => AuthRepository(ref.watch(dioProvider)));

final authProvider = StateNotifierProvider<AuthViewmodel, Member?>(
  (ref) => AuthViewmodel(ref.watch(authRepositoryProvider)),
);
