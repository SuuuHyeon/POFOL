import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final baseUrl = dotenv.env['BASE_URL'];

class DioClient {
  final Dio _dio = Dio();

  DioClient(String baseUrl) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(
        milliseconds: 3000,
      ), // 연결 타임아웃 (ms)
      receiveTimeout: const Duration(
        milliseconds: 3000,
      ), // 수신 타임아웃 (ms)
      headers: {'Content-Type': 'application/json'}, // 공통 헤더
    );
  }

  Dio get dio => _dio;
}

final dioProvider = Provider((ref) => DioClient(dotenv.env['BASE_URL']!).dio);