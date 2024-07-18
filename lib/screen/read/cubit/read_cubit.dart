import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_make_read/config/config.dart';
import 'package:qr_make_read/database/database.dart';
import 'package:qr_make_read/model/model.dart';
import 'package:qr_make_read/screen/read/repository/read_repository.dart';
import 'package:qr_make_read/widget/widget.dart';
import 'package:url_launcher/url_launcher.dart';

part 'read_state.dart';

class ReadCubit extends Cubit<ReadState> {
  ReadCubit({required this.databaseRepository}): super(ReadState(historyList: []));

  final DatabaseRepository databaseRepository;
  final ReadRepository readRepository = ReadRepository();

  Future<void> init() async {
    await load();
  }

  Future<void> onQRViewCreated(Barcode qrData, BuildContext context) async {
    if(qrData.code == state.qrData?.code) return;
    logger.d("qrData: ${qrData.code}");
    emit(state.copyWith(status: ReadStatus.scanSuccess, qrData: qrData));

    // 데이터베이스에 저장
    await databaseRepository.save(qrData: qrData.code ?? '', databaseType: DatabaseType.scan);
    await load();

    if ((qrData.code ?? "").contains("http")) {
      logger.d("1234");
      launchUrl(Uri.parse(qrData.code ?? ""));
    } else {
      CustomAlertDialog().showAlertDialog(
        context: context,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PrettyQrView.data(
                      data: state.qrData?.code ?? "",
                      decoration: const PrettyQrDecoration(
                          background: Colors.white,
                          shape: PrettyQrRoundedSymbol(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(0.0)))
                      )
                  ),
                ),
              ),
              onTap: () async {
                await context.read<ReadCubit>().exportQrImage();
              },
            ),
            const SizedBox(height: 10.0,),
            Text(state.qrData?.code ?? "",
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () async {
                      context.read<ReadCubit>().copyText(state.qrData?.code ?? "");
                      Navigator.of(context).pop();
                    },
                    child: const Text('Copy', style: TextStyle(color: Colors.blueAccent),)
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close', style: TextStyle(color: Colors.red),)
                ),
              ],
            )
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      );
    }
  }

  Future<void> load() async {
    try {
      emit(state.copyWith(status: ReadStatus.loading));
      final list = await databaseRepository.load(databaseType: DatabaseType.scan);
      emit(state.copyWith(status: ReadStatus.readyToScan, historyList: list));
    } catch (e) {
      // crashlytics
    }
  }

  Future<void> delete(int index) async {
    try {
      emit(state.copyWith(status: ReadStatus.loading));
      if(state.historyList?[index].data == (state.qrData?.code ?? "")) {
        emit(state.copyWith(qrData: Barcode("", BarcodeFormat.qrcode, [])));
      }
      await databaseRepository.delete(id: state.historyList?[index].id ?? -99);

      final list = await databaseRepository.load(databaseType: DatabaseType.scan);
      emit(state.copyWith(historyList: list));
    } catch (e) {
      // crashlytics
    }
  }

  Future<void> copyText(String data) async {
    try {
      await Clipboard.setData(ClipboardData(text: data));
    } catch (e) {
      // crashlytics
    }
  }

  Future<void> exportQrImage() async {
    if ((state.qrData?.code ?? "").isEmpty) return;
    try {
      readRepository.exportQrImage(state.qrData?.code ?? "");
    } catch (e) {
      // crashlytics
    }
  }
}