import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suhyeon_portfolio/presentation/pages/add_portfolio_page.dart';
import 'package:suhyeon_portfolio/providers/web_view_controller_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GithubWebViewPage extends ConsumerWidget {
  const GithubWebViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerNotifier = ref.read(webViewControllerProvider.notifier);
    final controller = ref.watch(webViewControllerProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller == null) {
        controllerNotifier.initialize('https://github.com/SuuuHyeon');
      }
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
            ),
            onPressed: () {
              controllerNotifier.goBack();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 25,
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ],
        ),
        body: controller == null
            ? Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : WebViewWidget(controller: controller));
  }
}
