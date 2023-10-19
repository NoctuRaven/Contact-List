import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseContact {
  DatabaseContact._();

  static final DatabaseContact instance = DatabaseContact._();

  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _iniDatabase();
  }

  _iniDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'contactList4.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_contact);
    for (var i in _initialValues) {
      await db.execute(i);
    }
  }

  String get _contact => '''
create table contact(
 id INTEGER PRIMARY KEY,
 name TEXT NOT NULL,
 email TEXT NOT NULL,
 phone TEXT NOT NULL,
 imagePath TEXT,
 isFavorite INTEGER NOT NULL
); ''';

  List<String> get _initialValues => [
        "INSERT INTO contact (name,email,phone,isfavorite) VALUES('Altair','altair@gmail.com','99729601',0);",
        "INSERT INTO contact (name,email,phone,isfavorite) VALUES('Anderson','anderson@gmail.com','99863101',0);",
        "INSERT INTO contact (name,email,phone,isfavorite) VALUES('Carlos','carlos@gmail.com','88929601',0);",
        "INSERT INTO contact (name,email,phone,isfavorite) VALUES('Vicente','vicente@gmail.com','99729601',0);",
        "INSERT INTO contact (name,email,phone,isfavorite) VALUES('Ricardo','ricardo@gmail.com','96829601',0);",
        "INSERT INTO contact (name,email,phone,isfavorite) VALUES('Filipe','filipe@gmail.com','99727777',0);",
        "INSERT INTO contact (name,email,phone,isfavorite) VALUES('Silvan','silvan@gmail.com','96688277',0);",
        "INSERT INTO contact (name,email,phone,isfavorite) VALUES('Sara','sara@gmail.com','66668727',0);",
        "INSERT INTO contact (name,email,phone,isfavorite) VALUES('Nando','Nando@gmail.com','9333855',0);",
        "INSERT INTO contact (name,email,phone,isfavorite) VALUES('Cirilo','cirilo@gmail.com','29789871',0);",
      ];
}
