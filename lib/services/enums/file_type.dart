enum FileType { image, document, pdf, txt }

extension FileTypeExtension on FileType {
  String get value {
    switch (this) {
      case FileType.image:
        return 'image';
      case FileType.document:
        return 'document';
      case FileType.pdf:
        return 'pdf';
      case FileType.txt:
        return 'txt';
      default:
        return 'image';
    }
  }

  String get imageUrl {
    switch (this) {
      case FileType.image:
        return 'assets/Icons/fileFormat/png.png';
      case FileType.document:
        return 'assets/Icons/fileFormat/doc.png';
      case FileType.pdf:
        return 'assets/Icons/fileFormat/pdf.png';
      case FileType.txt:
        return 'assets/Icons/fileFormat/txt.png';
      default:
        return 'assets/Icons/fileFormat/pdf.png';
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
    case 'pdf':
    case 'pdfa':
    case 'pdfx':
      return FileType.pdf;
    case 'doc':
    case 'docx':
    case 'docm':
    case 'docb':
      return FileType.document;
    case 'txt':
    case 'csv':
    case 'md':
      return FileType.txt;
    default:
      return FileType.document;
  }
}
