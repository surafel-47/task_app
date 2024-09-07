import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
// import 'package:sqflite_common_ffi/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize sqflite_ffi
    sqfliteFfiInit();

    final String path = join(await getDatabasesPath(), 'tasks.db');

    return await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE tasks (
              id TEXT PRIMARY KEY,
              title TEXT,
              description TEXT,
              dueDate TEXT,
              isCompleted INTEGER
            )
          ''');
        },
      ),
    );
  }
}
