class Section {
  String title = '';
  List<String> points = [];

  Section({
    required this.title,
    required this.points,
  });

  Section.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    points = map['points'] is Iterable ? List.from(map['points']) : [];
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'points': points};
  }
}

class Demonstration {
  String id = '';
  String title = '';
  String? imageUrl;
  String? videoUrl;
  List<Section> sections = [];

  Demonstration({
    required this.title,
    required this.imageUrl,
    required this.videoUrl,
    required this.sections,
  });

  Demonstration.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    imageUrl = map['imageUrl'];
    videoUrl = map['videoUrl'];
    sections = map['sections'] is Iterable
        ? List.from(map['sections'])
            .map((section) => Section.fromMap(section))
            .toList()
        : [];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'sections': sections.map((section) => section.toMap()).toList(),
    };
  }
}
