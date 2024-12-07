import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:suhyeon_portfolio/data/model/portfolio.dart';
import 'package:suhyeon_portfolio/providers/portfolio_viewmodel.dart';

class PortfolioDetailPage extends ConsumerStatefulWidget {
  final Portfolio portfolio;

  const PortfolioDetailPage({required this.portfolio, Key? key})
      : super(key: key);

  @override
  ConsumerState<PortfolioDetailPage> createState() => _PortfolioDetailPageState();
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
    _descriptionController = TextEditingController(text: widget.portfolio.description);
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

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(portfolioViewmodelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "포트폴리오 수정" : "포트폴리오 상세"),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isEditing ? _buildEditForm(viewModel) : _buildPortfolioDetail(),
      ),
    );
  }

  /// 상세 보기 UI
  Widget _buildPortfolioDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.portfolio.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          widget.portfolio.description,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        widget.portfolio.fileUrl.endsWith('.pdf')
            ? ElevatedButton(
          onPressed: () {
            // PDF 열기 기능
          },
          child: const Text("PDF 열기"),
        )
            : Image.network(
          widget.portfolio.fileUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            ref.read(portfolioViewmodelProvider).deletePortfolio(widget.portfolio.id);
            Navigator.pop(context);
          },
          child: const Text("삭제"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
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
          child: Text(_selectedFile == null ? "파일 선택" : "선택된 파일: ${_selectedFile!.name}"),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = false;
                });
              },
              child: const Text("취소"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
