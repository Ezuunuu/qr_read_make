import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';

import 'package:qr_make_read/database/database.dart';
import 'package:qr_make_read/model/model.dart';
import 'package:qr_make_read/screen/screen.dart';


part 'write_state.dart';

class WriteCubit extends Cubit<WriteState> {
  WriteCubit({required this.databaseRepository}): super(WriteState(historyList: []));

  final DatabaseRepository databaseRepository;
  final WriteRepository writeRepository = WriteRepository();

  Future<void> init() async {
    await loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      emit(state.copyWith(status: WriteStatus.loading));
      final list = await databaseRepository.load(databaseType: DatabaseType.create);
      emit(state.copyWith(status: WriteStatus.init, historyList: list));
    } catch (e) {
      // crashlytics
    }
  }

  Future<void> onMakeQRCode(String value) async {
    try {
      emit(state.copyWith(qrData: value));

      // 데이터베이스에 넣어 히스토리를 남긴다.
      await databaseRepository.save(qrData: value, databaseType: DatabaseType.create);

      // 데이터베이스 다시 로드
      await loadHistory();
    } catch (e) {
      // crashlytics
    }
  }

  Future<void> exportQrImage() async {
    if (state.qrData.isEmpty) return;
    try {
      writeRepository.exportQrImage(state.qrData);
    } catch (e) {
      // crashlytics
    }
  }

  Future<void> delete(int index) async {
    try {
      emit(state.copyWith(status: WriteStatus.loading));
      await databaseRepository.delete(id: state.historyList?[index].id ?? -99);
      final list = await databaseRepository.load(databaseType: DatabaseType.scan);
      emit(state.copyWith(historyList: list));
    } catch (e) {
      // crashlytics
    }
  }
}