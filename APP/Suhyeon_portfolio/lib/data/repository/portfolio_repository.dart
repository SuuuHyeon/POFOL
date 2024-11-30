import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suhyeon_portfolio/data/DioClient.dart';
import 'package:suhyeon_portfolio/data/model/portfolio.dart';
import 'package:suhyeon_portfolio/providers/secure_storage_provider.dart';

class PortfolioRepository {
  final Dio _dio;
  final SecureStorage _secureStorage;

  PortfolioRepository(this._dio, this._secureStorage);

  /// 포트폴리오 업로드
  Future<bool> uploadPortfolio(
      String title, String description, PlatformFile file) async {
    final accessToken = await _secureStorage.read('accessToken');
    FormData formData = FormData.fromMap({
      "title": title,
      "description": description,
      "file": await MultipartFile.fromFile(file.path!, filename: file.name),
    });

    final response = await _dio.post(
      '/api/portfolio/upload',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('파일 업로드에 실패했습니다.');
    }
  }

  /// 포트폴리오 전체 리스트 조회
  Future<List<Portfolio>> getPortfolioList() async {
    final accessToken = await _secureStorage.read('accessToken');
    final response = await _dio.post(
      '/api/portfolio/list',
      options: Options(
        // 헤더에 토큰 넣어줘야 함
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );

    if (response.statusCode == 200) {
      final List<Portfolio> data = response.data
          .map((e) => Portfolio.fromJson(e))
          .toList()
          .cast<Portfolio>();
      return data;
    } else {
      throw Exception('포트폴리오 리스트를 불러오는데 실패했습니다.');
    }
  }
}

final portfolioRepositoryProvider = Provider<PortfolioRepository>(
  (ref) => PortfolioRepository(
      ref.read(dioProvider), ref.read(secureStorageProvider)),
);
