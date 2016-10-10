library database;

import 'package:rethinkdb_driver/rethinkdb_driver.dart';

const _dataBaseAddres = '192.168.1.113';

class DataBaseMixin {
  Rethinkdb database;
  Connection _connection;

  setUpDataBase(
      {String ip: _dataBaseAddres,
      int port: 28015,
      String user,
      String password}) async {
    DbList databases;

    database = new Rethinkdb();

    _connection = await database.connect(host: ip, port: port);
    databases = await database.dbList().run(_connection);

    if (databases.contains('Pages') == false) {
      await database.dbCreate('Pages').run(_connection);
    }
    _connection.use('Pages');

    await database.tableCreate('pages').run(_connection);
  }
}
