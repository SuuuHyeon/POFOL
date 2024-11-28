import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suhyeon_portfolio/providers/auth_provider.dart';
import 'package:suhyeon_portfolio/theme/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  String? selectedPosition; // 로컬 상태로 포지션 관리

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("회원가입", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 이름 필드
              _buildTextField(
                controller: nameController,
                label: "이름",
                hintText: "이름",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "이름을 입력해주세요";
                  }
                  if (value.length < 2 || value.length > 20) {
                    return "이름은 2~20자 이내로 입력해주세요";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // 이메일 필드
              _buildTextField(
                controller: emailController,
                label: "이메일",
                hintText: "이메일",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "유효한 이메일을 입력해주세요";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // 비밀번호 필드
              _buildTextField(
                controller: passwordController,
                label: "비밀번호",
                hintText: "비밀번호",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6 || value.length > 20) {
                    return "비밀번호는 6~20자 이내로 입력해주세요";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // 포지션 선택 (Dropdown)
              _buildDropdownField(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 35),
        child: Consumer(builder: (context, ref, child) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // 회원가입 로직 실행
                try {
                  final result =
                      await ref.read(authProvider.notifier).registerMember(
                            email: emailController.text,
                            password: passwordController.text,
                            name: nameController.text,
                            position: selectedPosition ?? '',
                          );
                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("회원가입이 완료되었습니다."),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.go('/login');

                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text("회원가입"),
          );
        }),
      ),
    );
  }

  // 공통 텍스트 필드 위젯
  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
        ),
      ],
    );
  }

  // Dropdown 필드 위젯
  Widget _buildDropdownField() {
    final List<String> positions = [
      "프론트엔드",
      "백엔드",
      "풀스택",
      "모바일",
      "기획",
      "디자인",
      "마케팅"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "포지션",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(8),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          hint: Text("포지션 선택"),
          items: positions
              .map((position) => DropdownMenuItem(
                    value: position,
                    child: Text(position),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedPosition = value;
            });
          },
          validator: (value) => value == null ? "포지션을 선택해주세요" : null,
        ),
      ],
    );
  }
}
