import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

final log = Logger('Database');

initDB() async {
// Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "database.db");

// Check if the database exists
  var exists = await databaseExists(path);

  if (!exists) {
    // Should happen only the first time you launch your application
    log.info("initDB() - Creating new copy from asset");

    // Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load(join("assets", "database.db"));
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);

  } else {
    log.info("initDB() - Opening existing database");
  }
// open the database
  return await openDatabase(path);
}