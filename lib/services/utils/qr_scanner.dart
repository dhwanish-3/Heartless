import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QRScanner {
  static Future<String> scanQRCode() async {
    try {
      String codeSanner = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR); //barcode scanner
      return codeSanner;
    } catch (e) {
      return e.toString();
    }
  }
}
