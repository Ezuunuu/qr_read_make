part of 'home_cubit.dart';

enum HomeStatus {
  init,
  loading,
  error
}

class HomeState {
  HomeState(
      {
        this.status = HomeStatus.init,
        this.index = 0
      }
  );

  final HomeStatus status;
  final int index;

  HomeState copyWith({HomeStatus? status, int? index}) {
    return HomeState(
      status: status ?? this.status,
      index: index ?? this.index,
    );
  }

}