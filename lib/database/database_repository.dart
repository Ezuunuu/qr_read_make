import 'package:qr_make_read/config/custom_exception.dart';
import 'package:qr_make_read/model/model.dart';

enum DatabaseType {
  all,
  scan,
  create,
}

class DatabaseRepository {
  Future<List<Qr_history>> load({required DatabaseType databaseType}) async {
    try {
      final dbModels = Qr_history()
          .select()
          .type
          .equals(databaseType == DatabaseType.scan ? true : false)
          .orderByDesc(['createDate'])
          .toList();
      return dbModels;
    } catch(e) {
      throw CustomException(errorCode: 0, where: 'Database', errorBody: e);
    }
  }

  Future<void> save({required String qrData, required DatabaseType databaseType}) async {
    try {
      Qr_history.saveAll(
          [
            Qr_history.fromMap(
                {
                  'data': qrData,
                  'createDate': DateTime.now(),
                  'type': databaseType == DatabaseType.scan ? true : false
                }
            )
          ]
      );
    } catch(e) {
      throw CustomException(errorCode: 1, where: 'Database', errorBody: e);
    }
  }

  Future<void> delete({required int id}) async {
    if (id == -99) throw CustomException(errorCode: 0, where: 'Database', errorBody: "Invalid index");
    try {
      final res = await Qr_history()
          .select()
          .id
          .equals(id)
          .delete(true);
      if (!res.success) {
        throw Exception("Can not delete");
      }
    } catch(e) {
      throw CustomException(errorCode: 0, where: 'Database', errorBody: e);
    }
  }

  Future<void> deleteAll({DatabaseType databaseType = DatabaseType.all}) async {
    try {
      dynamic res;
      if (databaseType == DatabaseType.all) {
        res = await Qr_history()
            .select()
            .delete(true);
      } else {
        res = await Qr_history()
            .select()
            .type
            .equals(databaseType == DatabaseType.scan ? true : false)
            .delete(true);
      }
      if (!res.success) {
        throw Exception("Can not delete");
      }
    } catch(e) {
      throw CustomException(errorCode: 0, where: 'Database', errorBody: e);
    }
  }
}