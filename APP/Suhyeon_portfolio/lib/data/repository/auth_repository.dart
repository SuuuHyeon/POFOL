import 'package:dio/dio.dart';
import 'package:suhyeon_portfolio/data/model/member.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  /// 회원가입 요청
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String position,
  }) async {
    try {
      final member = Member(
        email: email,
        password: password,
        name: name,
        position: position,
      );

      final response = await _dio.post(
        '/api/member/register',
        data: member.toJson(),
      );
      print(response.realUri);

      if (response.statusCode == 200) {
        return true; // 성공
      } else {
        throw('회원가입 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // 서버 응답에 따른 메시지 처리
      final statusCode = e.response?.statusCode;
      if (statusCode == 409) {
        throw '이미 가입된 이메일입니다.';
      } else if (statusCode == 500) {
        throw '서버 오류가 발생했습니다.';
      } else {
        throw '회원가입 중 알 수 없는 오류 발생: $e';
      }
    } catch (e) {
      throw '회원가입 중 알 수 없는 오류 발생: $e';
    }
  }

  /// 로그인
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      Member member = Member(email: email, password: password);
      final response = await _dio.post(
        '/api/member/login',
        data: member.toJson(),
      );

      if (response.statusCode == 200) {
        return true; // 성공
      } else {
        throw('로그인 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // 서버 응답에 따른 메시지 처리
      final statusCode = e.response?.statusCode;
      final msg = e.response?.data;
      if (statusCode == 401) {
        throw msg;
      } else if (statusCode == 500) {
        throw '서버 오류가 발생했습니다.';
      } else {
        throw '로그인 중 알 수 없는 오류 발생: $e';
      }
    } catch (e) {
      throw '로그인 중 알 수 없는 오류 발생: $e';
    }
  }
}
