import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:refills/features/core/models/refill.dart';

class RefillDatabase {
  static final RefillDatabase instance = RefillDatabase._init();
  static Database? _database;

  RefillDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('refills.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE refills (
        id TEXT PRIMARY KEY,
        amount REAL,
        cost REAL,
        date TEXT,
        fillPercentage REAL,
        odometer INTEGER
      )
    ''');
  }

  Future<void> deleteRefill(String id) async {
    final db = await instance.database;
    await db.delete('refills', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertRefill(Refill refill) async {
    final db = await instance.database;
    await db.insert('refills', {
      'id': refill.id,
      'amount': refill.amount,
      'cost': refill.cost,
      'date': refill.date.toIso8601String(),
      'fillPercentage': refill.fillPercentage,
      'odometer': refill.odometer,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Refill>> getAllRefills() async {
    final db = await instance.database;
    final maps = await db.query('refills', orderBy: 'date DESC');
    return maps
        .map(
          (map) => Refill(
            id: map['id'] as String,
            amount: map['amount'] as double,
            cost: map['cost'] as double,
            date: DateTime.parse(map['date'] as String),
            fillPercentage: map['fillPercentage'] as double,
            odometer: map['odometer'] as int,
          ),
        )
        .toList();
  }
}
