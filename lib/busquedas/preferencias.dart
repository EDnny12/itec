import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "mai.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Preferencias(titulo TEXT,de TEXT)",
         );


  }

  Future<int> saveUser(String titulo,String de) async {
    var dbClient = await db;
    return await dbClient.rawInsert("insert into Preferencias values(?,?)",['$titulo','$de']);

  }

  Future<int> deleteUser(String titulo) async {
    var dbClient = await db;
   return await dbClient.rawDelete("delete from Preferencias where Titulo=?",['$titulo']);

  }

  Future<List<Map>> getUser() async {
    var dbClient = await db;
    return await dbClient.rawQuery('SELECT * FROM Preferencias');


  }
  Future<List<Map>> verificar(String titulo) async {
    var dbClient = await db;
    return  await dbClient.rawQuery('SELECT * FROM Preferencias where Titulo=?',['$titulo']);


  }




}