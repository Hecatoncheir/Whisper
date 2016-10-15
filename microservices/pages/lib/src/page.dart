library page;

import 'package:ex_map/ex_map.dart';
import 'package:uuid/uuid.dart';

class Page extends ExtendedMap {
  Page({id, path, title, description}) {
    protectedKeys.addAll(['id']);
    types = {'path': String, 'title': String, 'description': String};
    this.id = new Uuid().v4();
  }

  get id => this['id'];
  set id(value) => setProtectedField('id', value);

  get path => this['path'];
  set path(value) => this['path'] = value;

  get title => this['title'];
  set title(value) => this['title'] = value;

  get description => this['description'];
  set description(value) => this['description'] = value;
}
