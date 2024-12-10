import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:suhyeon_portfolio/data/model/portfolio.dart';
import 'package:suhyeon_portfolio/presentation/pages/add_portfolio_page.dart';
import 'package:suhyeon_portfolio/providers/portfolio_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioDetailPage extends ConsumerStatefulWidget {
  final Portfolio portfolio;

  const PortfolioDetailPage({required this.portfolio, Key? key})
      : super(key: key);

  @override
  ConsumerState<PortfolioDetailPage> createState() =>
      _PortfolioDetailPageState();
}

class _PortfolioDetailPageState extends ConsumerState<PortfolioDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  PlatformFile? _selectedFile;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.portfolio.title);
    _descriptionController =
        TextEditingController(text: widget.portfolio.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _openFile(String fileUrl) async {
    if (fileUrl.endsWith('.pdf')) {
      // PDF 파일을 외부 앱으로 열기
      final Uri url = Uri.parse(fileUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // URL을 열 수 없는 경우
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PDF를 열 수 없습니다.")),
        );
      }
    } else {
      // 이미지 파일을 확대/축소 가능한 화면으로 열기
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text("이미지 보기"),
            ),
            body: Center(
              child: PhotoView(
                imageProvider: NetworkImage(fileUrl),
                backgroundDecoration:
                const BoxDecoration(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(portfolioViewmodelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          isEditing ? "포트폴리오 수정" : "포트폴리오",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          // if (!isEditing)
            /// 드롭다운메뉴로 수정, 삭제 클릭하기
            PopupMenuButton(
              color: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditing = true;
                          context.pop();
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 17,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '수정',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(portfolioViewmodelProvider)
                            .deletePortfolio(widget.portfolio.id);
                        context.pop();
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delete_forever,
                            size: 17,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '삭제',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                ];
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isEditing ? _buildEditForm(viewModel) : _buildPortfolioDetail(),
      ),
    );
  }

  Widget _buildPortfolioDetail() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 기술 스택 (Chip)
          if (widget.portfolio.techList.isNotEmpty) ...[
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    "🛠️ Skills  🛠",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.portfolio.techList
                        .map(
                          (tech) => Chip(
                            label: Text(tech),
                            backgroundColor: Colors.grey.shade200,
                            labelStyle: const TextStyle(color: Colors.black),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],

          /// 제목
          Text(
            widget.portfolio.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          /// 설명
          Text(
            widget.portfolio.description,
            style: TextStyle(
              fontSize: 17,
              color: Colors.black.withOpacity(0.8),
              height: 1.5, // 줄 간격 조정
            ),
          ),
          const SizedBox(height: 16),

          /// 파일 또는 이미지
          if (widget.portfolio.fileUrl.endsWith('.pdf'))
            ElevatedButton.icon(
              onPressed: () {
                // PDF 열기 기능
                _openFile(widget.portfolio.fileUrl);
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("PDF 열기"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            )
          else
            InkWell(
              onTap: () {
                _openFile(widget.portfolio.fileUrl);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.portfolio.fileUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// 수정 UI
  Widget _buildEditForm(PortFolioViewmodel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: "제목"),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descriptionController,
          maxLines: 5,
          decoration: const InputDecoration(labelText: "설명"),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _pickFile,
          child: Text(_selectedFile == null
              ? "파일 선택"
              : "선택된 파일: ${_selectedFile!.name}"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = false;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: const Text("취소"),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedTitle = _titleController.text.trim();
                final updatedDescription = _descriptionController.text.trim();
                if (updatedTitle.isNotEmpty && updatedDescription.isNotEmpty) {
                  await viewModel.updatePortfolio(
                    widget.portfolio.id,
                    updatedTitle,
                    updatedDescription,
                    _selectedFile!,
                  );
                  setState(() {
                    isEditing = false;
                  });
                }
              },
              child: const Text("저장"),
            ),
          ],
        ),
      ],
    );
  }
}
