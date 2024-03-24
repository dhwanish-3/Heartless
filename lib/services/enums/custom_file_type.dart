enum CustomFileType { image, document, pdf }

extension CustomFileTypeExtension on CustomFileType {
  String get value {
    switch (this) {
      case CustomFileType.image:
        return 'image';
      case CustomFileType.document:
        return 'document';
      case CustomFileType.pdf:
        return 'pdf';
      default:
        return 'image';
    }
  }

  String get imageUrl {
    switch (this) {
      case CustomFileType.image:
        return 'assets/Icons/fileFormat/png.png';
      case CustomFileType.document:
        return 'assets/Icons/fileFormat/doc.png';
      case CustomFileType.pdf:
        return 'assets/Icons/fileFormat/pdf.png';
      default:
        return 'assets/Icons/fileFormat/pdf.png';
    }
  }
}

CustomFileType customFileTypeFromExtension(String extension) {
  switch (extension) {
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return CustomFileType.image;
    case 'pdf':
    case 'pdfa':
    case 'pdfx':
      return CustomFileType.pdf;
    case 'doc':
    case 'docx':
    case 'docm':
    case 'docb':
      return CustomFileType.document;
    default:
      return CustomFileType.document;
  }
}

List<String> fileExtensionsFromCustomFileType(CustomFileType fileType) {
  switch (fileType) {
    case CustomFileType.image:
      return ['jpg', 'jpeg', 'png', 'gif'];
    case CustomFileType.pdf:
      return ['pdf', 'pdfa', 'pdfx'];
    case CustomFileType.document:
      return ['doc', 'docx', 'docm', 'docb'];
    default:
      return ['doc', 'docx', 'docm', 'docb'];
  }
}
