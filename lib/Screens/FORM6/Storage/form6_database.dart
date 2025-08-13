import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Form6Database {
  static final Form6Database instance = Form6Database._init();
  static Database? _database;

  Form6Database._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('form6.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE form6 (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      senderName TEXT,
      DONumber TEXT,
      senderDesignation TEXT,
      district TEXT,
      region TEXT,
      division TEXT,
      area TEXT,
      sampleCodeData TEXT,
      collectionDate TEXT,
      placeOfCollection TEXT,
      SampleName TEXT,
      QuantitySample TEXT,
      article TEXT,
      preservativeAdded INTEGER,
      preservativeName TEXT,
      preservativeQuantity TEXT,
      personSignature INTEGER,
      slipNumber TEXT,
      DOSignature INTEGER,
      sampleCodeNumber TEXT,
      sealImpression INTEGER,
      numberofSeal TEXT,
      formVI INTEGER,
      FoemVIWrapper INTEGER,
      isOtherInfoComplete INTEGER,
      isSampleInfoComplete INTEGER
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE form6 ADD COLUMN isOtherInfoComplete INTEGER');
      await db.execute('ALTER TABLE form6 ADD COLUMN isSampleInfoComplete INTEGER');
      await db.execute('ALTER TABLE form6 ADD COLUMN isSampleDetailsComplete INTEGER');
      await db.execute('ALTER TABLE form6 ADD COLUMN isPreservativeInfoComplete INTEGER');
      await db.execute('ALTER TABLE form6 ADD COLUMN isSealInfoComplete INTEGER');
      await db.execute('ALTER TABLE form6 ADD COLUMN isFinalReviewComplete INTEGER');
    }
  }

  Future<void> insertForm6Data(Map<String, dynamic> data) async {
    final db = await instance.database;
    await db.delete('form6'); // Only 1 entry at a time
    await db.insert('form6', data);
  }

  Future<Map<String, dynamic>?> fetchForm6Data() async {
    final db = await instance.database;
    final result = await db.query('form6', limit: 1);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> clearForm6Data() async {
    final db = await instance.database;
    await db.delete('form6');
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await instance.database;
    return await db.query('form6');
  }
}
