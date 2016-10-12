library database;

import 'dart:async';
import 'package:rethinkdb_driver/rethinkdb_driver.dart';

part 'actions.dart';

const _dataBaseAddres = '192.168.1.113';

class DataBaseMixin extends Object with DataBaseActionsMixin {
  Rethinkdb database;
  Connection _connection;
  final String baseName = 'Pages';

  setUpDataBase(
      {String ip: _dataBaseAddres,
      int port: 28015,
      String user,
      String password}) async {
    DbList databases;
    TableList tableList;

    database = new Rethinkdb();

    _connection = await database.connect(host: ip, port: port);

    databases = await database.dbList().run(_connection);

    if (databases.contains(baseName) == false) {
      await database.dbCreate('Pages').run(_connection);
    }

    _connection.use(baseName);
    tableList = await database.tableList().run(_connection);

    if (tableList.contains('pages') == false) {
      await database.tableCreate('pages').run(_connection);
    }

    if (tableList.contains('descriptions') == false) {
      await database.tableCreate('descriptions').run(_connection);
    }
  }
}
