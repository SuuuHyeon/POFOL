import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 사용자 정보
    final String userName = "김수현";
    final String userBio = "Flutter 개발자 | 신입";
    final String userProfileImage = "https://cdn.pixabay.com/photo/2017/12/10/13/37/christmas-3009949_1280.jpg";

    // 예시 포트폴리오 데이터
    final List<Map<String, String>> portfolios = [
      {
        'title': 'Project 1',
        'description': 'Description of Project 1',
        'image': 'https://cdn.pixabay.com/photo/2017/12/10/13/37/christmas-3009949_1280.jpg',
      },
      {
        'title': 'Project 2',
        'description': 'Description of Project 2',
        'image': 'https://cdn.pixabay.com/photo/2017/12/10/13/37/christmas-3009949_1280.jpg',
      },
      {
        'title': 'Project 3',
        'description': 'Description of Project 3',
        'image': 'https://cdn.pixabay.com/photo/2017/12/10/13/37/christmas-3009949_1280.jpg',
      },
      {
        'title': 'Project 3',
        'description': 'Description of Project 3',
        'image': 'https://cdn.pixabay.com/photo/2017/12/10/13/37/christmas-3009949_1280.jpg',
      },
      {
        'title': 'Project 3',
        'description': 'Description of Project 3',
        'image': 'https://cdn.pixabay.com/photo/2017/12/10/13/37/christmas-3009949_1280.jpg',
      },
      {
        'title': 'Project 3',
        'description': 'Description of Project 3',
        'image': 'https://cdn.pixabay.com/photo/2017/12/10/13/37/christmas-3009949_1280.jpg',
      },

      // 추가 포트폴리오 항목을 여기에 추가
    ];

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView( // 전체 페이지를 스크롤 가능하게 만듭니다.
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 사용자 프로필 섹션
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(userProfileImage), // 프로필 이미지 추가
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userBio,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                '포트폴리오',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // 포트폴리오 카드 레이아웃
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(), // GridView가 스크롤되지 않도록 설정
                shrinkWrap: true, // GridView의 크기를 부모에 맞게 조정
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 한 줄에 2개의 카드
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.75, // 카드 비율 조정
                ),
                itemCount: portfolios.length,
                itemBuilder: (context, index) {
                  final portfolio = portfolios[index];
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                          child:
                          Image.network(
                            portfolio['image']!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            portfolio['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            portfolio['description']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
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
}
