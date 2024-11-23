import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suhyeon_portfolio/presentation/pages/login_page.dart';
import 'package:suhyeon_portfolio/routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  // .env 파일 로드
  await dotenv.load(fileName: "assets/config/.env");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'portfolio APP',
        routerConfig: Routes.router,

        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
    );
  }
}
