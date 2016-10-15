library page;

import 'package:ex_map/ex_map.dart';
import 'package:uuid/uuid.dart';

class Page extends ExtendedMap {
  Page({identificator, path, title, description}) {
    protectedKeys.addAll(['identificator']);
    types = {'path': String, 'title': String, 'description': String};
    this.identificator = new Uuid().v4();
  }

  get identificator => this['identificator'];
  set identificator(value) => setProtectedField('identificator', value);

  get path => this['path'];
  set path(value) => this['path'] = value;

  get title => this['title'];
  set title(value) => this['title'] = value;

  get description => this['description'];
  set description(value) => this['description'] = value;
}
