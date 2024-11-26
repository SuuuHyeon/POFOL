class Portfolio {
  final String title;
  final String description;
  final String fileUrl;

  Portfolio({
    required this.title,
    required this.description,
    required this.fileUrl,
  });

  Portfolio copyWith({
    String? title,
    String? description,
    String? fileUrl,
  }) {
    return Portfolio(
      title: title ?? this.title,
      description: description ?? this.description,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }


factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? 'No description',
      fileUrl: json['fileUrl'] ?? '', // 서버에서 파일 URL 반환
    );
  }
}
