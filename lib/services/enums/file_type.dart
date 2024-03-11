enum FileType { image, document }

extension FileTypeExtension on FileType {
  String get value {
    switch (this) {
      case FileType.image:
        return 'image';
      case FileType.document:
        return 'document';
      default:
        return 'image';
    }
  }
}

FileType fileTypeFromExtension(String extension) {
  switch (extension) {
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return FileType.image;
    default:
      return FileType.document;
  }
}
