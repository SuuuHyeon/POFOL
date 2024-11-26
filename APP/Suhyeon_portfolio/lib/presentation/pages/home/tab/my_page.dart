import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suhyeon_portfolio/presentation/pages/add_portfolio_page.dart';
import 'package:suhyeon_portfolio/providers/portfolio_viewmodel.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  void initState() {
    super.initState();
    // 페이지가 로드될 때 포트폴리오 리스트를 가져옴
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(portfolioViewmodelProvider).getPortfolioList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final portfolioViewModel = ref.watch(portfolioViewmodelProvider);

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 사용자 프로필 파트
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        "https://cdn.pixabay.com/photo/2017/12/10/13/37/christmas-3009949_1280.jpg"),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "김수현",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Flutter 개발자 | 신입",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// 포트폴리오 리스트
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
                    }, // 포트폴리오 추가 기능
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // 포트폴리오 카드 레이아웃
              portfolioViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : portfolioViewModel.portfolioList.isEmpty
                      ? const Center(
                          child: Text('포트폴리오가 없습니다.'),
                        )
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 한 줄에 2개의 카드
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 0.75, // 카드 비율 조정
                          ),
                          itemCount: portfolioViewModel.portfolioList.length,
                          itemBuilder: (context, index) {
                            final portfolio =
                                portfolioViewModel.portfolioList[index];
                            final isPdf = portfolio.fileUrl.endsWith('.pdf');
                            return Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  isPdf
                                      ? GestureDetector(
                                          onTap: () {
                                            // PDF 뷰어로 열기
                                            openPdfViewer(portfolio.fileUrl);
                                          },
                                          child: Container(
                                            height: 100,
                                            color: Colors.grey.shade300,
                                            child: const Center(
                                              child: Icon(
                                                Icons.picture_as_pdf,
                                                size: 50,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(12.0)),
                                          child: Image.network(
                                            portfolio.fileUrl,
                                            height: 100,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Center(
                                                child: Icon(Icons.broken_image),
                                              );
                                            },
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      portfolio.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      portfolio.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  // ClipRRect(
                                  //   borderRadius: const BorderRadius.vertical(
                                  //       top: Radius.circular(12.0)),
                                  //   child: Image.network(
                                  //     'http://localhost:8080${portfolio.fileUrl}',
                                  //     height: 100,
                                  //     width: double.infinity,
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Text(
                                  //     portfolio.title,
                                  //     style: const TextStyle(
                                  //       fontSize: 18,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding:
                                  //   const EdgeInsets.symmetric(horizontal: 8.0),
                                  //   child: Text(
                                  //     portfolio.description,
                                  //     style: const TextStyle(
                                  //       fontSize: 14,
                                  //       color: Colors.grey,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  void openPdfViewer(String pdfUrl) {
    // PDF 뷰어 열기 (예: 특정 화면으로 이동 또는 외부 앱 사용)
    print("PDF 열기: $pdfUrl");
  }
}
