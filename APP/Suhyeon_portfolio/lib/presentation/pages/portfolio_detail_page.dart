import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:suhyeon_portfolio/data/model/portfolio.dart';
import 'package:suhyeon_portfolio/presentation/pages/add_portfolio_page.dart';
import 'package:suhyeon_portfolio/providers/portfolio_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_colors.dart';

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
  late List<String> selectedTechList;
  final TextEditingController _skillController = TextEditingController();

  PlatformFile? _selectedFile;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.portfolio.title);
    _descriptionController =
        TextEditingController(text: widget.portfolio.description);
    selectedTechList = List.from(widget.portfolio.techList);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// 파일 선택
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  /// 파일 열기
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
              backgroundColor: Colors.white,
              title: const Text("포트폴리오"),
            ),
            body: Center(
              child: PhotoView(
                imageProvider: NetworkImage(fileUrl),
                backgroundDecoration: const BoxDecoration(color: Colors.white),
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
                  onTap: () {
                    setState(() {
                      isEditing = true;
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
                PopupMenuItem(
                  onTap: () {
                    viewModel.deletePortfolio(widget.portfolio.id);
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
              ];
            },
          ),
        ],
      ),

      /// 화면 body 부분, 스크롤 가능
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isEditing
            ? _buildEditForm(viewModel, selectedTechList)
            : _buildPortfolioDetail(),
      ),
    );
  }

  Widget _buildPortfolioDetail() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 기술 스택
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

          /// 파일 or 이미지
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
  Widget _buildEditForm(
      PortFolioViewmodel viewModel, List<String> selectedTechList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목 입력
        Text(
          "제목",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          maxLength: 30,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1.2, color: Colors.black),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          "설명",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // 설명 입력
        TextField(
          controller: _descriptionController,
          maxLength: 200,
          maxLines: 5,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1.2, color: Colors.black),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 16),

        // 기술 스택 선택
        const Text(
          "기술 스택",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // DropdownButton<String>(
        //   hint: const Text("기술 스택 추가"),
        //   items: viewModel.availableSkills
        //       .where((tech) => !selectedTechList.contains(tech))
        //       .map((tech) => DropdownMenuItem(
        //     value: tech,
        //     child: Text(tech),
        //   ))
        //       .toList(),
        //   onChanged: (value) {
        //     if (value != null) {
        //       setState(() {
        //         selectedTechList.add(value);
        //       });
        //     }
        //   },
        // ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    builder: (context) => _buildSkillModal(viewModel),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.build_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '리스트',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: TextField(
                controller: _skillController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  hintText: '직접 입력',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(width: 1.2, color: Colors.black),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty && !selectedTechList.contains(value)) {
                    setState(() {
                      selectedTechList.add(value);
                      _skillController.clear();
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedTechList
              .map(
                (tech) => Chip(
                  label: Text(tech),
                  backgroundColor: Colors.blue.shade100,
                  side: BorderSide.none,
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () {
                    setState(() {
                      selectedTechList.remove(tech);
                    });
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),

        // 파일 선택
        Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  _pickFile();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.attach_file, color: Colors.white, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '파일 선택',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: _selectedFile != null ? Colors.grey.shade100 : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedFile?.name ?? '파일을 선택해주세요',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ),
                      if (_selectedFile != null)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFile = null;
                            });
                          },
                          child: const Icon(Icons.close, size: 20, color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 40),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 취소 버튼
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    isEditing = false;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade400),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "취소",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 저장 버튼
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final updatedTitle = _titleController.text.trim();
                  final updatedDescription = _descriptionController.text.trim();
                  if (updatedTitle.isNotEmpty &&
                      updatedDescription.isNotEmpty &&
                      selectedTechList.isNotEmpty) {
                    await viewModel.updatePortfolio(
                      widget.portfolio.id,
                      updatedTitle,
                      updatedDescription,
                      selectedTechList,
                      _selectedFile!,
                    );
                    context.pop();
                    setState(() {
                      isEditing = false;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("모든 필드를 입력해주세요.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.third,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "저장",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSkillModal(PortFolioViewmodel portfolioViewModel) {
    return StatefulBuilder(
      builder: (context, modalSetState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                '기술 스택 선택',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: portfolioViewModel.availableSkills.length,
                  itemBuilder: (context, index) {
                    final skill = portfolioViewModel.availableSkills[index];
                    final isSelected = selectedTechList.contains(skill);
                    return CheckboxListTile(
                      activeColor: AppColors.primary,
                      value: isSelected,
                      title: Text(skill),
                      onChanged: (bool? value) {
                        modalSetState(() {
                          if (value == true) {
                            selectedTechList.add(skill);
                          } else {
                            selectedTechList.remove(skill);
                          }
                        });
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
