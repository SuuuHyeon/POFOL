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

  // List<String> selectedSkills = []; // 선택된 기술스택 리스트
  /// 기술 스택 리스트
  final List<String> availableSkills = [
    'Flutter',        // 모바일 및 웹 애플리케이션 개발
    'Dart',           // Flutter의 프로그래밍 언어
    'React',          // 사용자 인터페이스 구축을 위한 JavaScript 라이브러리
    'Node.js',       // 서버 사이드 애플리케이션을 위한 JavaScript 런타임
    'Spring Boot',    // Java 기반의 웹 애플리케이션 프레임워크
    'Python',         // 범용 프로그래밍 언어, 데이터 과학 및 웹 개발에 많이 사용
    'Django',         // Python으로 작성된 웹 프레임워크
    'Flask',          // 경량 Python 웹 프레임워크
    'Kotlin',         // Android 애플리케이션 개발을 위한 현대적인 언어
    'Go',             // 구글에서 개발한 시스템 프로그래밍 언어
    'GraphQL',        // API 쿼리 언어
    'Docker',         // 애플리케이션을 컨테이너화하는 플랫폼
    'Kubernetes',     // 컨테이너 오케스트레이션 플랫폼
    'Ruby on Rails',  // Ruby로 작성된 웹 애플리케이션 프레임워크
    'Swift',          // iOS 애플리케이션 개발을 위한 언어
    'TypeScript',     // JavaScript의 상위 집합으로, 정적 타입을 지원
    'Firebase',       // Google의 모바일 및 웹 애플리케이션 개발 플랫폼
    'AWS',            // Amazon Web Services, 클라우드 컴퓨팅 서비스
    'Azure',          // Microsoft의 클라우드 컴퓨팅 서비스
    'Terraform',      // 인프라를 코드로 관리하는 도구
    'Redis',          // 인메모리 데이터 구조 저장소
  ];

  bool isLoading = false;

  PortFolioViewmodel(this.portfolioRepository) : super();

  /// 포트폴리오 업로드
  Future<void> uploadPortfolio(
      String title, String description, List<String> techList, PlatformFile file) async {
    try {
      final response =
          await portfolioRepository.uploadPortfolio(title, description, techList, file);
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
