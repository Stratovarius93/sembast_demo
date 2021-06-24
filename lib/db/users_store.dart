import 'package:sembast/sembast.dart';
import 'package:sembast_demo/db/db.dart';
import 'package:sembast_demo/models/user.dart';

class UsersStore {
  UsersStore._internal();
  static UsersStore _instance = UsersStore._internal();
  static UsersStore get instance => _instance;
  Database _database = DB.instance.database;
  final StoreRef<String, Map> _storeRef = StoreRef<String, Map>('users');

  Future<List<User>> find({Finder? finder}) async {
    List<RecordSnapshot<String, Map>> snapshots =
        await this._storeRef.find(this._database, finder: finder);
    return snapshots.map((RecordSnapshot<String, Map> snap) {
      //print('key: ${snap.key}');
      return User.fromJson(snap.value);
    }).toList();
  }

  Future<void> add(User user) async {
    await this._storeRef.record(user.id).put(this._database, user.toJson());
  }

  Future<int> delete({Finder? finder}) async {
    return await this._storeRef.delete(this._database, finder: finder);
  }
}
