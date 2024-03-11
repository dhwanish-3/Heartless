enum MessageType { text, image, document }

MessageType messageTypeFromExtension(String extension) {
  switch (extension) {
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return MessageType.image;
    default:
      return MessageType.document;
  }
}
