import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'credito.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE registros(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fecha TEXT,
            periodo INTEGER,
            tasa REAL,
            cuota REAL,
            saldo_inicial REAL,
            interes REAL,
            amortizacion REAL,
            saldo_final REAL
          )
        ''');
      },
    );
    return _db!;
  }
}