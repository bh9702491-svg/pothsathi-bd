import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'sql_script.dart';

/// অ্যাপের লোকাল SQLite ডাটাবেস (অফলাইনেও কাজ করে)।
class AppDatabase {
  static const String _dbName = 'pothsathi.db';
  static const int _dbVersion = 1;
  static Database? _db;

  static Future<Database> get instance async {
    return _db ??= await _open();
  }

  static Future<Database> _open() async {
    final path = p.join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _runAssetScript(db, 'assets/db/schema.sql');
        await _runAssetScript(db, 'assets/db/seed_services.sql');
      },
    );
  }

  static Future<void> _runAssetScript(Database db, String assetPath) async {
    final script = await rootBundle.loadString(assetPath);
    for (final statement in splitSqlStatements(script)) {
      await db.execute(statement);
    }
  }
}
