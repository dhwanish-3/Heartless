class HealthDocumentTag {
  final String name;
  final String colorHexCode;

  HealthDocumentTag({required this.name, required this.colorHexCode});

  factory HealthDocumentTag.fromMap(Map<String, dynamic> map) {
    return HealthDocumentTag(
      name: map['name'],
      colorHexCode: map['colorHexCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'colorHexCode': colorHexCode,
    };
  }
}

class HealthDocument {
  String id = '';
  String name = '';
  String url = '';
  List<HealthDocumentTag> tags = [];
  DateTime createdAt = DateTime.now();

  HealthDocument(
      {required this.name,
      required this.url,
      required this.tags,
      required this.createdAt});

  HealthDocument.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    url = map['url'];
    tags = map['tags']
        .map<HealthDocumentTag>((tag) => HealthDocumentTag.fromMap(tag))
        .toList();
    createdAt = DateTime.parse(map['createdAt']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'tags': tags.map((tag) => tag.toMap()).toList(),
      'createdAt': createdAt,
    };
  }
}
