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
      version: 8,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE form6 (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId TEXT,
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
      isSampleInfoComplete INTEGER,
      districtOptions TEXT,
      districtIdByName TEXT,
      regionOptions TEXT,
      regionIdByName TEXT,
      divisionOptions TEXT,
      divisionIdByName TEXT,
      natureOptions TEXT,
      natureIdByName TEXT,
      lab TEXT,
      labOptions TEXT,
      labIdByName TEXT,
      sealNumber TEXT,
      sealNumberOptions TEXT,
      sendingSampleLocation TEXT,
      uploadedDocuments TEXT,
      documentNames TEXT,
      documentName TEXT
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
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE form6 ADD COLUMN districtOptions TEXT');
      await db.execute('ALTER TABLE form6 ADD COLUMN districtIdByName TEXT');
      await db.execute('ALTER TABLE form6 ADD COLUMN regionOptions TEXT');
      await db.execute('ALTER TABLE form6 ADD COLUMN regionIdByName TEXT');
      await db.execute('ALTER TABLE form6 ADD COLUMN divisionOptions TEXT');
      await db.execute('ALTER TABLE form6 ADD COLUMN divisionIdByName TEXT');
      await db.execute('ALTER TABLE form6 ADD COLUMN natureOptions TEXT');
      await db.execute('ALTER TABLE form6 ADD COLUMN natureIdByName TEXT');
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE form6 ADD COLUMN lab TEXT');
      await db.execute('ALTER TABLE form6 ADD COLUMN labOptions TEXT');
      await db.execute('ALTER TABLE form6 ADD COLUMN labIdByName TEXT');
      await db.execute('ALTER TABLE form6 ADD COLUMN sendingSampleLocation TEXT');
    }
    if (oldVersion < 5) {
      await db.execute('ALTER TABLE form6 ADD COLUMN uploadedDocuments TEXT');
      await db.execute('ALTER TABLE form6 ADD COLUMN documentNames TEXT');
    }
    if (oldVersion < 6) {
      await db.execute('ALTER TABLE form6 ADD COLUMN documentName TEXT');
    }
    if (oldVersion < 7) {
      await db.execute('ALTER TABLE form6 ADD COLUMN sealNumber TEXT');
      await db.execute('ALTER TABLE form6 ADD COLUMN sealNumberOptions TEXT');
    }
    if (oldVersion < 8) {
      await db.execute('ALTER TABLE form6 ADD COLUMN userId TEXT');
    }

  }

  // Insert or update per user
  Future<void> insertForm6Data(Map<String, dynamic> data, {required String userId}) async {
    final db = await instance.database;

    // Check if a record already exists for this user
    final existing = await db.query('form6', where: 'userId = ?', whereArgs: [userId]);

    data['userId'] = userId;

    if (existing.isNotEmpty) {
      // Update
      await db.update('form6', data, where: 'userId = ?', whereArgs: [userId]);
    } else {
      // Insert
      await db.insert('form6', data);
    }
  }

  Future<Map<String, dynamic>?> fetchForm6Data({required String userId}) async {
    final db = await instance.database;

    final result = await db.query(
      'form6',
      columns: [
        'id',
        'userId',
        'senderName',
        'DONumber',
        'senderDesignation',
        'district',
        'region',
        'division',
        'area',
        'sampleCodeData',
        'collectionDate',
        'placeOfCollection',
        'SampleName',
        'QuantitySample',
        'article',
        'preservativeAdded',
        'preservativeName',
        'preservativeQuantity',
        'personSignature',
        'slipNumber',
        'DOSignature',
        'sampleCodeNumber',
        'sealImpression',
        'numberofSeal',
        'formVI',
        'FoemVIWrapper',
        'isOtherInfoComplete',
        'isSampleInfoComplete',
        'districtOptions',
        'districtIdByName',
        'regionOptions',
        'regionIdByName',
        'divisionOptions',
        'divisionIdByName',
        'natureOptions',
        'natureIdByName',
        'lab',
        'labOptions',
        'labIdByName',
        'sealNumber',
        'sealNumberOptions',
        'sendingSampleLocation',
        'uploadedDocuments',
        'documentNames',
        'documentName',
      ],
      where: 'userId = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<void> updateForm6Data({required String userId, required Map<String, dynamic> data}) async {
    final db = await instance.database;
    await db.update('form6', data, where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> clearForm6Data({required String userId}) async {
    final db = await instance.database;
    await db.delete(
      'form6',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }


  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await instance.database;
    return await db.query('form6');
  }
}
