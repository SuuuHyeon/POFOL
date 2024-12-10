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
  final TextEditingController skillController = TextEditingController();

  PlatformFile? selectedFile;
  List<String> selectedSkills = [];

  @override
  Widget build(BuildContext context) {
    final portfolioViewModel = ref.watch(portfolioViewmodelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '포트폴리오 업로드',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('포트폴리오 제목'),
            const SizedBox(height: 6),
            _buildTextField(
              controller: titleController,
              hintText: '포트폴리오 제목을 입력하세요',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('포트폴리오 설명'),
            const SizedBox(height: 6),
            _buildTextField(
              controller: descriptionController,
              hintText: '포트폴리오 설명을 입력하세요',
              maxLines: 5,
              maxLength: 200,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('기술스택'),
            const SizedBox(height: 8),
            _buildSkillSelector(portfolioViewModel),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: selectedSkills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Colors.blue.shade100,
                  side: BorderSide.none,
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () {
                    setState(() {
                      selectedSkills.remove(skill);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('첨부파일'),
            const SizedBox(height: 8),
            _buildFileSelector(),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () => _uploadPortfolio(context, portfolioViewModel),
        child: BottomAppBar(
          color: AppColors.primary,
          height: 50,
          child: const Center(
            child: Text(
              '업로드',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String hintText = '',
    int maxLines = 1,
    int maxLength = 30,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 1.2, color: Colors.black),
        ),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildSkillSelector(PortFolioViewmodel portfolioViewModel) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                builder: (context) => _buildSkillModal(portfolioViewModel),
              );
            },
            child: _buildButton('리스트', Icons.build_rounded),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: TextField(
            controller: skillController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              hintText: '직접 입력',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(width: 1.2, color: Colors.black),
              ),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty && !selectedSkills.contains(value)) {
                setState(() {
                  selectedSkills.add(value);
                  skillController.clear();
                });
              }
            },
          ),
        ),
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
                    final isSelected = selectedSkills.contains(skill);
                    return CheckboxListTile(
                      activeColor: AppColors.primary,
                      value: isSelected,
                      title: Text(skill),
                      onChanged: (bool? value) {
                        modalSetState(() {
                          if (value == true) {
                            selectedSkills.add(skill);
                          } else {
                            selectedSkills.remove(skill);
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

  Widget _buildButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileSelector() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () async {
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(type: FileType.any);

              if (result != null) {
                setState(() {
                  selectedFile = result.files.single;
                });
              }
            },
            child: _buildButton('파일 선택', Icons.upload_file),
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
              color: selectedFile != null ? Colors.grey.shade100 : Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedFile?.name ?? '파일을 선택해주세요',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
                if (selectedFile != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFile = null;
                      });
                    },
                    child: const Icon(Icons.close, size: 20, color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _uploadPortfolio(
      BuildContext context, PortFolioViewmodel portfolioViewModel) async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedSkills.isEmpty ||
        selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 항목을 입력해주세요.')),
      );
      return;
    }
    await portfolioViewModel.uploadPortfolio(
      titleController.text,
      descriptionController.text,
      selectedSkills,
      selectedFile!,
    );
    await ref.read(portfolioViewmodelProvider).getPortfolioList();
    context.pop();
  }
}
