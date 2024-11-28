import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suhyeon_portfolio/data/DioClient.dart';
import 'package:suhyeon_portfolio/data/model/member.dart';
import 'package:suhyeon_portfolio/data/repository/auth_repository.dart';

class MemberNotifier extends StateNotifier<Member?> {
  final AuthRepository repository;

  MemberNotifier(this.repository) : super(null);

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
      return await repository.login(
        email: email,
        password: password,
      );
    } catch (e) {
      print('로그인실패(viewModel) $e');
      rethrow;
    }
  }
}


final authRepositoryProvider = Provider((ref) => AuthRepository(ref.watch(dioProvider)));

final memberProvider = StateNotifierProvider<MemberNotifier, Member?>(
  (ref) => MemberNotifier(ref.watch(authRepositoryProvider)),
);