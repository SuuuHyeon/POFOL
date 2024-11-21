import 'package:flutter/material.dart';

class PortfolioListPage extends StatelessWidget {
  const PortfolioListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> portfolios = [
      {
        'title': 'Project 1',
        'description': 'Description of Project 1',
        'image': 'https://via.placeholder.com/150',
      },
      {
        'title': 'Project 2',
        'description': 'Description of Project 2',
        'image': 'https://via.placeholder.com/150',
      },
      {
        'title': 'Project 3',
        'description': 'Description of Project 3',
        'image': 'https://via.placeholder.com/150',
      },
    ];

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 한 줄에 2개의 카드
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 0.75, // 카드 비율 조정
            ),
            itemCount: portfolios.length,
            itemBuilder: (context, index) {
              final portfolio = portfolios[index];
              return Card(
                color: Colors.white,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                      child: Image.network(
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
        ),
      ),
    );
  }
}
