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
      version: 12,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE FSOLIMS (
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
      DOSignature INTEGER,
      sampleCodeNumber TEXT,
      sealImpression INTEGER,
      numberofSeal TEXT,
      formVI INTEGER,
      FoemVIWrapper INTEGER,
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
      doSlipNumbers TEXT,
      doSealNumbersOptions TEXT,
      doSealNumbersIdByName TEXT,
      sendingSampleLocation TEXT,
      uploadedDocuments TEXT,
      documentNames TEXT,
      documentName TEXT,
      Lattitude TEXT,
      Longitude TEXT
    )
    ''');

    // Table to store documents in chunks to avoid CursorWindow limits
    await db.execute('''
    CREATE TABLE IF NOT EXISTS Form6Documents (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId TEXT NOT NULL,
      docIndex INTEGER NOT NULL,
      name TEXT,
      mimeType TEXT,
      extension TEXT,
      sizeBytes INTEGER,
      chunkIndex INTEGER NOT NULL,
      data BLOB NOT NULL,
      UNIQUE(userId, docIndex, chunkIndex)
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 11) {
      // Drop old table and create new FSOLIMS table
      await db.execute('DROP TABLE IF EXISTS form6');
      await _createDB(db, 11);
    }
    if (oldVersion < 12) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS Form6Documents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        docIndex INTEGER NOT NULL,
        name TEXT,
        mimeType TEXT,
        extension TEXT,
        sizeBytes INTEGER,
        chunkIndex INTEGER NOT NULL,
        data BLOB NOT NULL,
        UNIQUE(userId, docIndex, chunkIndex)
      )
      ''');
    }
  }

  // Insert or update per user
  Future<void> insertForm6Data(Map<String, dynamic> data, {required String userId}) async {
    final db = await instance.database;

    // Check if a record already exists for this user
    final existing = await db.query('FSOLIMS', where: 'userId = ?', whereArgs: [userId]);

    data['userId'] = userId;

    if (existing.isNotEmpty) {
      // Update
      await db.update('FSOLIMS', data, where: 'userId = ?', whereArgs: [userId]);
    } else {
      // Insert
      await db.insert('FSOLIMS', data);
    }
  }

  Future<Map<String, dynamic>?> fetchForm6Data({required String userId}) async {
    final db = await instance.database;

    final result = await db.query(
      'FSOLIMS',
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
        'DOSignature',
        'sampleCodeNumber',
        'sealImpression',
        'numberofSeal',
        'formVI',
        'FoemVIWrapper',
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
        'doSlipNumbers',
        'doSealNumbersOptions',
        'doSealNumbersIdByName',
        'sendingSampleLocation',
        'uploadedDocuments',
        'documentNames',
        'documentName',
        'Lattitude',
        'Longitude',
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
    await db.update('FSOLIMS', data, where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> clearForm6Data({required String userId}) async {
    final db = await instance.database;
    await db.delete(
      'FSOLIMS',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<void> clearDocumentsForUser({required String userId}) async {
    final db = await instance.database;
    await db.delete(
      'Form6Documents',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<void> insertDocumentChunk({
    required String userId,
    required int docIndex,
    required int chunkIndex,
    required List<int> data,
    String? name,
    String? mimeType,
    String? extension,
    int? sizeBytes,
  }) async {
    final db = await instance.database;
    await db.insert(
      'Form6Documents',
      {
        'userId': userId,
        'docIndex': docIndex,
        'chunkIndex': chunkIndex,
        'data': data,
        'name': name,
        'mimeType': mimeType,
        'extension': extension,
        'sizeBytes': sizeBytes,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, Object?>>> fetchDocumentRowsForUser({required String userId}) async {
    final db = await instance.database;
    return await db.query(
      'Form6Documents',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'docIndex ASC, chunkIndex ASC',
    );
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await instance.database;
    return await db.query('FSOLIMS');
  }
  
  Future<void> resetFSOLIMSTable() async {
    final db = await instance.database;
    // Drop existing table
    await db.execute('DROP TABLE IF EXISTS FSOLIMS');
    // Recreate schema (FSOLIMS and ensure Form6Documents exists)
    await _createDB(db, 12);
  }

}
