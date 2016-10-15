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
      await database
          .tableCreate('pages', {'primary_key': 'path'}).run(_connection);
      await database.table('pages').indexCreate('id').run(_connection);
    }

    if (tableList.contains('descriptions') == false) {
      await database.tableCreate(
          'descriptions', {'primary_key': 'path'}).run(_connection);
      await database.table('descriptions').indexCreate('id').run(_connection);
    }
  }

  Future<Map> savePage({Map page}) async {
    Map pageDetails = new Map.from(page);
    pageDetails.remove('description');

    await database.table('pages').insert(pageDetails).run(_connection);

    Map pageDescription = {
      'pageId': page['id'],
      'path': page['path'],
      'description': page['description']
    };

    await database
        .table('descriptions')
        .insert(pageDescription)
        .run(_connection);

    Map readyPage = await getPageByPath(path: page['path']);

    return readyPage;
  }

  Future<Map> updatePage({Map page}) async {
    Map newValues = new Map.from(page);
    newValues.remove('description');

    await database
        .table('pages')
        .filter({'path': page['path']})
        .update(newValues)
        .run(_connection);

    await database.table('descriptions').filter({'path': page['path']}).update(
        {'description': page['description']}).run(_connection);

    Map readyPage = await getPageByPath(path: page['path']);
    return readyPage;
  }

  Future<Map> getPageByPath({String path}) async {
    Cursor readyPageRow = await database
        .table('pages')
        .filter({'path': path})
        .eqJoin('path', database.table('descriptions'))
        .without({'right': 'pageId'})
        .zip()
        .run(_connection);

    Map readyPage = await readyPageRow.first;
    return readyPage;
  }

  Future<Map> deletePage({String pageId}) async {
    return new Map();
  }
}
