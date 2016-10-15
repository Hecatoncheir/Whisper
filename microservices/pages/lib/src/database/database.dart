library database;

import 'dart:async';
import 'package:rethinkdb_driver/rethinkdb_driver.dart';

const _dataBaseAddres = '192.168.1.113';

class DataBaseMixin {
  Rethinkdb database;
  Connection _connection;
  final String baseName = 'Pages';

  setUpDataBase(
      {String ip: _dataBaseAddres,
      int port: 28015,
      String user,
      String password}) async {
    List databases;
    List tableList;

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

  Future<Map> savePage({Map page}) async {
    // Map pageDetails = {''}dd
    // database.table('pages').insert(page[])
    return page;
  }

  Future<Map> updatePage({Map page}) async {
    return page;
  }

  Future<Map> getPageByPath({String path}) async {
    return new Map();
  }
}
