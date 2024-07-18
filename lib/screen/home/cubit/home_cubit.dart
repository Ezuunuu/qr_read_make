import 'package:bloc/bloc.dart';
import 'package:qr_make_read/config/config.dart';
import 'package:qr_make_read/database/database.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.databaseRepository}): super(HomeState());

  final DatabaseRepository databaseRepository;

  Future<void> init() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      await databaseRepository.load(databaseType: DatabaseType.all);
      emit(state.copyWith(status: HomeStatus.init));
    } catch (e) {
      // crashlytics report
      logger.e(e.toString());
    }
  }

  Future<void> changeIndex({required int index}) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading, index: index));
      await databaseRepository.load(databaseType: DatabaseType.all);
      emit(state.copyWith(status: HomeStatus.init));
    } catch (e) {
      // crashlytics report
      logger.e(e.toString());
    }
  }
}