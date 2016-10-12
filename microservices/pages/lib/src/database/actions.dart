part of database;

class DataBaseActionsMixin {
  Future<Map> getPageByPath({String path}) {}
  Future<String> getPageDescription({String path, int identificator}) async {}
}
