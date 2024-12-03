class Portfolio {
  final int id;
  final String title;
  final String description;
  final String fileUrl;

  Portfolio({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
  });

  Portfolio copyWith({
    int? id,
    String? title,
    String? description,
    String? fileUrl,
  }) {
    return Portfolio(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }


factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? 'No description',
      fileUrl: json['fileUrl'] ?? '', // 서버에서 파일 URL 반환
    );
  }
}
