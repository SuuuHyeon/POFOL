import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suhyeon_portfolio/providers/auth_provider.dart';
import 'package:suhyeon_portfolio/providers/portfolio_viewmodel.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioViewModel = ref.watch(portfolioViewmodelProvider);
    final memberInfo = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 사용자 프로필
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2017/12/10/13/37/christmas-3009949_1280.jpg"),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${memberInfo?.name}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${memberInfo?.position} / ${memberInfo?.tier?.name}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push('/github');
                      },
                      child: Image.asset(
                        "assets/images/github_icon.png",
                        width: 45,
                      ),
                    ),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 20),

            /// 포트폴리오 섹션
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '포트폴리오',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.push('/add_portfolio');
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// 포트폴리오 슬라이드
            Expanded(
              child: portfolioViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : portfolioViewModel.portfolioList.isEmpty
                      ? const Center(child: Text('포트폴리오가 없습니다.'))
                      : PageView.builder(
                          itemCount: portfolioViewModel.portfolioList.length,
                          controller: PageController(viewportFraction: 0.85),
                          itemBuilder: (context, index) {
                            final portfolio =
                                portfolioViewModel.portfolioList[index];
                            final isPdf = portfolio.fileUrl.endsWith('.pdf');
                            return Transform.scale(
                              scale: 0.95,
                              child: Card(
                                color: Colors.white,
                                elevation: 7.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isPdf
                                        ? GestureDetector(
                                            onTap: () {
                                              openPdfViewer(portfolio.fileUrl);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius: const BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(16.0)),
                                              ),
                                              height: 200,
                                              child: const Center(
                                                child: Icon(
                                                  Icons.picture_as_pdf,
                                                  size: 80,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(16.0)),
                                            child: Image.network(
                                              portfolio.fileUrl,
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey.shade300,
                                                  height: 200,
                                                  child: const Center(
                                                    child: Icon(
                                                        Icons.broken_image,
                                                        size: 80),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            portfolio.title,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            portfolio.description,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void openPdfViewer(String pdfUrl) {
    print("PDF 열기: $pdfUrl");
  }
}
