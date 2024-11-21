import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suhyeon_portfolio/pages/home/tab/my_page.dart';
import 'package:suhyeon_portfolio/pages/home/tab/portfolio_list_page.dart';
import 'package:suhyeon_portfolio/pages/home/tab/portfolio_page.dart';
import 'package:suhyeon_portfolio/providers/bottom_state_provider.dart';
import 'package:suhyeon_portfolio/route/custom_router.dart';
import 'package:suhyeon_portfolio/theme/app_colors.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 바텀네비게이션 인덱스 상태를 적용시키기 위해 ref.watch로 인덱스를 가져옴 (read가 아닌 watch로 가져옴 read는 상태변경 불가능)
    final tabIndex = ref.watch(bottomStateProvider);
    // 바텀네비게이션 인덱스 변경을 위해 ref.read로 상태를 가져옴(상태 감지가 아닌 인덱스 변경을 위해 사용하기 때문에 read로 가져와도 됨)
    final bottomState = ref.read(bottomStateProvider.notifier);

    // 페이지 리스트
    final List<Widget> pages = [
      const PortfolioPage(),
      const PortfolioListPage(),
      const MyPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: tabIndex == 2
            ? Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text('프로필', style: TextStyle(fontSize: 28, letterSpacing: 1, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            : Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Image.asset(
                      'assets/images/app_logo.png',
                    ),
                  ),
                ],
              ),
        // leadingWidth 기기별 화면 크기에 따라 조절
        leadingWidth: 150,
        actions: [
          IconButton(
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: pages[tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        iconSize: 22,
        currentIndex: tabIndex,
        onTap: (index) {
          bottomState.changeState(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '이력서',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '포트폴리오',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
