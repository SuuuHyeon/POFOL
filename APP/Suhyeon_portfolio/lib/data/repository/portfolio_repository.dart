import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:suhyeon_portfolio/data/DioClient.dart';
import 'package:suhyeon_portfolio/data/model/portfolio.dart';

class PortfolioRepository {

  static PortfolioRepository get instance => PortfolioRepository();

  /// 포트폴리오 업로드
  Future<bool> uploadPortfolio(
      String title, String description, PlatformFile file) async {
    var dio = Dio();
    FormData formData = FormData.fromMap({
      "title": title,
      "description": description,
      "file": await MultipartFile.fromFile(file.path!, filename: file.name),
    });
    final response = await dio.post(
      'http://localhost:8080/api/portfolio/upload',
      data: formData,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('파일 업로드에 실패했습니다.');
    }
  }

  /// 포트폴리오 전체 리스트 조회
  Future<List<Portfolio>> getPortfolioList() async {
    var dio = Dio();
    final response = await dio.get('http://localhost:8080/api/portfolio/list');
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
