import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Userbox.dart';

class databox {


  var _db;

  Future<Database> get database async {
    if (_db != null) return _db;

    _db = openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE user(id INTEGER PRIMARY KEY, uid TEXT, nickname TEXT, auth TEXT, email TEXT, displayName TEXT, Grade INTEGER, Class INTEGER)",
        );
      },
      version: 1,
    );

    return _db;
  }


  Future<void> insertUser(Userbox userData) async {
    final Database db = await database;

    await db.insert(
      'user',
      userData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future getuser() async {


    final db = await database;

    // 모든 Memo를 얻기 위해 테이블에 질의합니다.
    final List<Map<String, dynamic>> maps = await db.query('memos');

    // List<Map<String, dynamic>를 List<Memo>으로 변환합니다.
    return List.generate(maps.length, (i) {
      return Userbox(
            id: maps[i]['id'],
            uid: maps[i]['id'],
            nickname: maps[i]['id'],
            auth: maps[i]['id'],
            email: maps[i]['id'],
            displayName: maps[i]['id'],
            signupDate: maps[i]['id'],
            photoURL: maps[i]['id'],
            Grade: maps[i]['id'],
            Class: maps[i]['id']
          );
    });




    // final Database db = await database;
    //
    // // 모든 Dog를 얻기 위해 테이블에 질의합니다.
    // final List list = await db.query('users');
    // final Map map = list[0];
    // // List<Map<String, dynamic>를 List<Dog>으로 변환합니다.
    // return Userbox(
    //   id: map['id'],
    //   uid: map['id'],
    //   nickname: map['id'],
    //   auth: map['id'],
    //   email: map['id'],
    //   displayName: map['id'],
    //   signupDate: map['id'],
    //   photoURL: map['id'],
    //   Grade: map['id'],
    //   Class: map['id']
    // );
  }

  Future<void> updateUser(Userbox userbox) async {
    // 데이터베이스 reference를 얻습니다.
    final db = await database;

    // 주어진 Dog를 수정합니다.
    await db.update(
      'user',
      userbox.toMap(),
      // Dog의 id가 일치하는 지 확인합니다.
      where: "id = ?",
      // Dog의 id를 whereArg로 넘겨 SQL injection을 방지합니다.
      whereArgs: [userbox.id],
    );
  }





}
