import 'package:heartless/services/enums/custom_file_type.dart';
import 'package:heartless/services/enums/event_tag.dart';

class HealthDocument {
  String id = '';
  String name = '';
  String url = '';
  List<EventTag> tags = [];
  CustomFileType customFileType = CustomFileType.pdf;
  DateTime createdAt = DateTime.now();

  HealthDocument(
      {required this.name,
      required this.url,
      required this.tags,
      required this.createdAt,
      required this.customFileType});

  HealthDocument.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    url = map['url'];
    tags = map['tags'].map<EventTag>((tag) => EventTag.values[tag]).toList();
    createdAt = map['createdAt'].toDate();
    customFileType = CustomFileType.values[map['customFileType']];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'tags': tags.map((tag) => tag.index).toList(),
      'createdAt': createdAt,
      'customFileType': customFileType.index,
    };
  }
}
