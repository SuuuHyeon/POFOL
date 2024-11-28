import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suhyeon_portfolio/presentation/pages/add_portfolio_page.dart';
import 'package:suhyeon_portfolio/presentation/pages/github_web_view_page.dart';
import 'package:suhyeon_portfolio/presentation/pages/home/main_page.dart';
import 'package:suhyeon_portfolio/presentation/pages/login_page.dart';
import 'package:suhyeon_portfolio/presentation/pages/register_page.dart';

class Routes {
  static GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      /// 메인 페이지
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(
          child: MainPage(),
        ),
      ),

      /// 로그인 페이지
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const MaterialPage(
          child: LoginPage(),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => const MaterialPage(
          child: RegisterPage(),
        ),
      ),
      GoRoute(
        path: '/add_portfolio',
        pageBuilder: (context, state) => const MaterialPage(
          child: AddPortfolioPage(),
        ),
      ),

      /// 깃허브 웹뷰 페이지
      GoRoute(
        path: '/github',
        pageBuilder: (context, state) => const MaterialPage(
          child: GithubWebViewPage(),
        ),
      ),
    ],
  );
}
