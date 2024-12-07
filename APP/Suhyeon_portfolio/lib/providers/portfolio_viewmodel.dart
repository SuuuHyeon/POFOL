import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suhyeon_portfolio/data/model/portfolio.dart';
import 'package:suhyeon_portfolio/data/repository/portfolio_repository.dart';

import '../data/DioClient.dart';

final baseUrl = dotenv.env['BASE_URL'];

class PortFolioViewmodel extends ChangeNotifier {
  final PortfolioRepository portfolioRepository;
  final List<Portfolio> portfolioList = [];
  bool isLoading = false;

  PortFolioViewmodel(this.portfolioRepository) : super();

  /// 포트폴리오 업로드
  Future<void> uploadPortfolio(
      String title, String description, PlatformFile file) async {
    try {
      final response =
          await portfolioRepository.uploadPortfolio(title, description, file);
      if (response) {
        print('파일 업로드 성공');
      } else {
        print('파일 업로드 실패');
      }
    } catch (e) {
      print(e);
    }
  }

  /// 포트폴리오 리스트 불러오기
  Future<void> getPortfolioList() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await portfolioRepository.getPortfolioList();
      print('포트폴리오 리스트 : $response');
      if (response.isEmpty) {
        portfolioList.clear();
        notifyListeners();
        return;
      }
      final updatedList = response
          .map((item) => item.copyWith(
              fileUrl: '$baseUrl${item.fileUrl}')) // fileUrl 앞에 baseUrl 붙임
          .toList();
      portfolioList.clear();
      portfolioList.addAll(updatedList);
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 포트폴리오 삭제
  Future<void> deletePortfolio(int portfolioId) async {
    try {
      isLoading = true;
      notifyListeners();
      await portfolioRepository.deletePortfolio(portfolioId);
      // portfolioList.removeWhere((element) => element.id == portfolioId);
      await getPortfolioList();
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 포트폴리오 수정
  Future<void> updatePortfolio(
      int portfolioId, String title, String description, PlatformFile file) async {
    try {
      isLoading == true;
      notifyListeners();
      await portfolioRepository.updatePortfolio(portfolioId, title, description, file);
      await getPortfolioList();
      notifyListeners();
    } catch (e){
      print('포트폴리오 수정 에러: $e');
    } finally {
      isLoading == false;
      notifyListeners();
    }
  }
}

// 포트폴리오뷰모델 프로바이더
final portfolioViewmodelProvider = ChangeNotifierProvider<PortFolioViewmodel>(
    (ref) => PortFolioViewmodel(ref.read(portfolioRepositoryProvider)));
