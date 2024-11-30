import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suhyeon_portfolio/data/DioClient.dart';
import 'package:suhyeon_portfolio/data/model/jwt_response_model.dart';
import 'package:suhyeon_portfolio/data/model/member.dart';
import 'package:suhyeon_portfolio/providers/secure_storage_provider.dart';

class AuthRepository {
  final Dio _dio;
  final SecureStorage _secureStorage;

  AuthRepository(this._dio, this._secureStorage);

  /// 회원가입 요청
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String position,
  }) async {
    try {
      final response = await _dio.post(
        '/api/member/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'position': position,
        },
      );
      print(response.realUri);

      if (response.statusCode == 200) {
        return true; // 성공
      } else {
        throw ('회원가입 실패: ${response.statusCode}');
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
  Future<JwtResponseModel> login({
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
        print('토큰정보 : ${response.data}');
        return JwtResponseModel.fromJson(response.data);
      } else {
        print('1');
        throw ('로그인 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // 서버 응답에 따른 메시지 처리
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        throw '이메일 또는 비밀번호가 일치하지 않습니다.';
      } else if (statusCode == 500) {
        throw '서버 오류가 발생했습니다.';
      } else {
        throw '로그인 중 알 수 없는 오류 발생: $e';
      }
    } catch (e) {
      throw '로그인 중 알 수 없는 오류 발생: $e';
    }
  }

  /// 유저 정보 조회
  Future<Member> getUserInfo(String accessToken) async {
    final response = await _dio.post('/api/member/me',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }));

    if (response.statusCode == 200) {
      return Member.fromJson(response.data);
    } else {
      throw ('유저 정보 조회 실패: ${response.statusCode}');
    }
  }

  /// 토큰 정보 수정
  Future<void> updateToken(String accessToken, String refreshToken) async {
    await _secureStorage.write('accessToken', accessToken);
    await _secureStorage.write('refreshToken', refreshToken);
  }

  /// 로컬 토큰 정보 조회 후 업데이트
  Future<void> getToken() async {
    final String? access = await _secureStorage.read('accessToken');
    final String? refresh = await _secureStorage.read('refreshToken');
    if (access != null && refresh != null) {
      await _secureStorage.write('accessToken', access);
      await _secureStorage.write('refreshToken', refresh);
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider), ref.watch(secureStorageProvider));
});