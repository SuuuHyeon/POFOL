import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suhyeon_portfolio/pages/login_page.dart';
import 'package:suhyeon_portfolio/route/custom_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'portfolio APP',
        routerConfig: CustomRouter.router,

        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
    );
  }
}
