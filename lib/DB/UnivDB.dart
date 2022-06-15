import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UnivDB {
  late Future<Database> _database;
  String _orderBy = 'univName ASC';

  static int lenght=0;

  _setInstance() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'circle_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE circles(id TEXT PRIMARY KEY, univName TEXT, univCode TEXT,preference INTEGER)",
        );
      },
      version: 1,
    );
  }

  setOrderBy(String order) {
    _orderBy = order;
  }

  Future<List<UnivInfo>> getInfo() async {
    await _setInstance();
    final Database db = await _database;
    final List<Map<String, dynamic>> maps =
        await db.query('circles', orderBy: _orderBy);
    lenght=maps.length;

    return List.generate(maps.length, (i) {
      return UnivInfo(
        id: maps[i]['id'],
        univName: maps[i]['univName'],
        univCode: maps[i]['univCode'],
        preference: maps[i]['preference'],
      );
    });
  }

  Future<void> deleteInfo(String id) async {
    await _setInstance();
    // 데이터베이스 reference를 얻습니다.
    final db = await _database;
    lenght--;
    // 데이터베이스에서 Dog를 삭제합니다.
    await db.delete(
      'circles',
      // 특정 dog를 제거하기 위해 `where` 절을 사용하세요
      where: "id = ?",
      // Dog의 id를 where의 인자로 넘겨 SQL injection을 방지합니다.
      whereArgs: [id],
    );
  }

  Future<void> insertInfo(UnivInfo univ) async {
    lenght++;
    print('추가됌');
    await _setInstance();
    final Database db = await _database;
    await db.insert(
      'circles',
      univ.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class UnivInfo {
  final String id;
  String univName;
  String univCode;
  int preference;

  UnivInfo({
    required this.id,
    required this.univName,
    required this.univCode,
    required this.preference,
  });

  // dog를 Map으로 변환합니다. key는 데이터베이스 컬럼 명과 동일해야 합니다.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'univName': univName,
      'univCode': univCode,
      'preference': preference,
    };
  }
}
