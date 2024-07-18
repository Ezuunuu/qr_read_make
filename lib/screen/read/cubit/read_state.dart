part of 'read_cubit.dart';

enum ReadStatus {
  init,
  loading,
  readyToScan,
  scanSuccess,
  error,
}

class ReadState {
  ReadState({this.status = ReadStatus.init, this.qrData, this.historyList});

  final ReadStatus status;
  final Barcode? qrData;

  final List<Qr_history>? historyList;

  ReadState copyWith({ReadStatus? status, Barcode? qrData, List<Qr_history>? historyList}) {
    return ReadState(
        status: status ?? this.status,
        qrData: qrData ?? this.qrData,
        historyList: historyList ?? this.historyList
    );
  }
}