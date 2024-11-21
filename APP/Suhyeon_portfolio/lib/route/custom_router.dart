import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suhyeon_portfolio/pages/home/main_page.dart';
import 'package:suhyeon_portfolio/pages/login_page.dart';

class CustomRouter {
  static GoRouter router = GoRouter(
    routes: [
      /// 메인 페이지
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(
          child: MainPage(
          ),
        ),
      ),
      /// 로그인 페이지
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(
          child: LoginPage(),
        ),
      ),
    ],
  );
}
