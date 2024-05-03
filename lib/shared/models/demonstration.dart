class Section {
  String title;
  List<String> points;

  Section({
    required this.title,
    required this.points,
  });

  Section.fromMap(Map<String, dynamic> data)
      : title = data['title'],
        points = List<String>.from(data['points']);
}

class Demonstration {
  String title;
  String imageUrl;
  String videoUrl;
  List<Section> sections;

  Demonstration({
    required this.title,
    required this.imageUrl,
    required this.videoUrl,
    required this.sections,
  });

  Demonstration.fromMap(Map<String, dynamic> data)
      : title = data['title'],
        imageUrl = data['imageUrl'],
        videoUrl = data['videoUrl'],
        sections = (data['sections'] as List)
            .map((item) => Section.fromMap(item))
            .toList();
}
