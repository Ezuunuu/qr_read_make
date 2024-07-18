import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_make_read/config/config.dart';
import 'package:share_plus/share_plus.dart';

class WriteRepository {
  Future<void> exportQrImage(String qrData) async {
    try {
      final qrCode = QrCode.fromData(data: qrData, errorCorrectLevel: QrErrorCorrectLevel.Q);
      final qrImage = QrImage(qrCode);
      final qrImageBytes = await qrImage.toImageAsBytes(
        size: 512,
        format: ImageByteFormat.png,
        decoration: const PrettyQrDecoration(
            background: Colors.white,
            shape: PrettyQrRoundedSymbol(
                borderRadius: BorderRadius.all(Radius.circular(0.0)))
        ),
      );
      String? dir = Platform.isAndroid ? (await getExternalStorageDirectory())?.path : (await getApplicationDocumentsDirectory()).path;
      final file = await File('$dir/qr_$qrData.png').create();
      await file.writeAsBytes(qrImageBytes!.buffer.asUint8List());
      Share.shareXFiles([XFile('$dir/qr_$qrData.png')], text: 'QR Code');
    } catch (e) {
      throw CustomException(errorCode: 0, where: 'Write', errorBody: e);
    }
  }
}