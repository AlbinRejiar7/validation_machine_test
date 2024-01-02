import 'package:hive_flutter/hive_flutter.dart';

class Database {
  final _db = Hive.box('myBox');

  List personList = [];


  Future<void> updatedatabase() async {
  await  _db.put('mylist', personList);
  }

  Future<void> loadfromdatabase() async {
     personList = _db.get('mylist');
  }

  void deleteallfromdatabase() async {
    _db.delete('mylist');
  }
}
