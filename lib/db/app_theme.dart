import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_demo/db/db.dart';

class MyAppTheme extends ChangeNotifier {
  MyAppTheme._internal();
  static MyAppTheme _instance = MyAppTheme._internal();
  static MyAppTheme get instance => _instance;

  final StoreRef _storeRef = StoreRef.main();
  final Database _db = DB.instance.database;

  bool _darkEnable = false;
  bool get darkEnable => _darkEnable;

  change(bool darkEnable) async {
    this._darkEnable = darkEnable;
    final dataSaved = await this
        ._storeRef
        .record('DARK_ENABLED')
        .put(this._db, this._darkEnable);
    print('Theme DARK_ENABLED: $dataSaved');
    notifyListeners();
  }

  Future<void> init() async {
    this._darkEnable =
        (await this._storeRef.record('DARK_ENABLED').get(_db)) ?? false;
  }
}
