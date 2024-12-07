import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suhyeon_portfolio/providers/portfolio_viewmodel.dart';
import 'package:suhyeon_portfolio/theme/app_colors.dart';

class AddPortfolioPage extends ConsumerStatefulWidget {
  const AddPortfolioPage({super.key});

  @override
  ConsumerState<AddPortfolioPage> createState() => _AddPortfolioPageState();
}

class _AddPortfolioPageState extends ConsumerState<AddPortfolioPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  PlatformFile? selectedFile; // 상태로 파일 저장

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '포트폴리오 업로드',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '포트폴리오 제목',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: '포트폴리오 제목을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '포트폴리오 설명',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '포트폴리오 설명을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '첨부파일',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(type: FileType.any);

                    if (result != null) {
                      setState(() {
                        selectedFile = result.files.single; // 파일 선택 상태 업데이트
                      });
                    }
                  },
                  child: const Text('파일 선택'),
                ),
                const SizedBox(width: 16),
                Text(
                  selectedFile?.name ?? '파일을 선택해주세요',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            // const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (selectedFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('파일을 선택해주세요!')),
                      );
                      return;
                    }
                    await ref.watch(portfolioViewmodelProvider).uploadPortfolio(
                          titleController.text,
                          descriptionController.text,
                          selectedFile!,
                        );
                    await ref
                        .read(portfolioViewmodelProvider)
                        .getPortfolioList();
                    context.pop();
                  },
                  child: Text('업로드'),
                ),
                SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text('취소'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          if (selectedFile == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('파일을 선택해주세요!')),
            );
            return;
          }
          await ref.watch(portfolioViewmodelProvider).uploadPortfolio(
            titleController.text,
            descriptionController.text,
            selectedFile!,
          );
          await ref
              .read(portfolioViewmodelProvider)
              .getPortfolioList();
          context.pop();
        },
        child: BottomAppBar(
          padding: EdgeInsets.only(top: 10),
            color: AppColors.primary,
            height: 50,
            child: Text(
              '업로드',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            )),
      ),
    );
  }
}
