import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suhyeon_portfolio/presentation/pages/portfolio_detail_page.dart';
import 'package:suhyeon_portfolio/providers/auth_provider.dart';
import 'package:suhyeon_portfolio/providers/portfolio_viewmodel.dart';
import 'package:suhyeon_portfolio/theme/app_colors.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioViewModel = ref.watch(portfolioViewmodelProvider);
    final memberInfo = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 사용자 프로필
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.push('/profile'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${memberInfo?.name}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      Text(
                        '${memberInfo?.position} / ${memberInfo?.tier?.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
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
                        width: 40,
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
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await portfolioViewModel.getPortfolioList();
                },
                color: AppColors.third,
                backgroundColor: Colors.white,
                child: portfolioViewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : portfolioViewModel.portfolioList.isEmpty
                        ? const Center(child: Text('포트폴리오가 없습니다.'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 40),
                            itemCount: portfolioViewModel.portfolioList.length,
                            itemBuilder: (context, index) {
                              final portfolio =
                                  portfolioViewModel.portfolioList[index];
                              final isPdf = portfolio.fileUrl.endsWith('.pdf');

                              return GestureDetector(
                                onTap: () {
                                  context.push('/portfolio_detail',
                                      extra: portfolio);
                                },
                                child: Container(
                                  height: 150, // 카드의 높이
                                  margin: const EdgeInsets.only(bottom: 25),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 10,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // 포트폴리오 제목
                                        Text(
                                          portfolio.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        // 기술 스택
                                        Text(
                                          portfolio.techList.join(', '),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const Spacer(),

                                        // 수정 날짜 및 파일 열람 버튼
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 16),
                                              child: Text(
                                                '${portfolio.updatedTime} 수정',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                // 파일 열람 로직
                                                // openFile(portfolio.fileUrl);
                                              },
                                              icon: const Icon(Icons.folder_open,
                                                  size: 16),
                                              label: const Text(
                                                '파일열기',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                textStyle:
                                                    const TextStyle(fontSize: 14),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
// 상단 이미지 or PDF 아이콘
// isPdf
//     ? Container(
//   height: 200,
//   decoration: BoxDecoration(
//     color: Colors.grey.shade200,
//     borderRadius: const BorderRadius.vertical(
//       top: Radius.circular(16),
//     ),
//   ),
//   child: const Center(
//     child: Icon(
//       Icons.picture_as_pdf,
//       size: 50,
//       color: Colors.red,
//     ),
//   ),
// )
//     : ClipRRect(
//   borderRadius: const BorderRadius.vertical(
//     top: Radius.circular(16),
//   ),
//   child: Image.network(
//     portfolio.fileUrl,
//     height: 200,
//     width: double.infinity,
//     fit: BoxFit.cover,
//     errorBuilder: (context, error, stackTrace) {
//       return Container(
//         color: Colors.grey.shade200,
//         height: 200,
//         child: const Center(
//           child: Icon(
//             Icons.broken_image,
//             size: 50,
//             color: Colors.grey,
//           ),
//         ),
//       );
//     },
//   ),
// ),
