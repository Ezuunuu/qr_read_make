part of 'write_cubit.dart';

enum WriteStatus {
  init,
  loading,
  success,
  error
}

class WriteState {
  WriteState({this.status = WriteStatus.init, this.qrData = "", this.historyList});

  final WriteStatus status;
  final String qrData;
  final List<Qr_history>? historyList;

  WriteState copyWith({WriteStatus? status, String? qrData, List<Qr_history>? historyList}) {
    return WriteState(
      status: status ?? this.status,
      qrData: qrData ?? this.qrData,
      historyList: historyList ?? this.historyList
    );
  }
}