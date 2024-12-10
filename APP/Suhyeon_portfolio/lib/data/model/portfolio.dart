class Portfolio {
  final int id;
  final String title;
  final String description;
  final List<String> techList;
  final String fileUrl;
  final String updatedTime;

  Portfolio({
    required this.id,
    required this.title,
    required this.description,
    required this.techList,
    required this.fileUrl,
    required this.updatedTime,
  });

  Portfolio copyWith({
    int? id,
    String? title,
    String? description,
    List<String>? techList,
    String? fileUrl,
    String? updatedTime,
  }) {
    return Portfolio(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      techList: techList ?? this.techList,
      fileUrl: fileUrl ?? this.fileUrl,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }


factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? 'No description',
      techList: List<String>.from(json['techList'] ?? []), // JSON 배열을 List<String>으로 변환
      fileUrl: json['fileUrl'] ?? '', // 서버에서 파일 URL 반환
      updatedTime: json['updatedTime'] ?? '0000-00-00',
    );
  }
}
