import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper{
  DBHelper._();//private constructor

  static final getInstanse=DBHelper._();

  ///TABLE_NOTE
  static final TABLE_NOTE='note';
  static final COLUMN_NOTE_SNO='s_no';
  static final COLUMN_NOTE_TITLE='title';
  static final COLUMN_NOTE_DESC='desc';

  Database? myDB;

  Future<Database>_getDB()async{
    myDB??=await _openDB();
    return myDB!;

  }

  Future<Database>_openDB()async{
    Directory appDir=await getApplicationDocumentsDirectory();

    String dbPath=join(appDir.path,"noteDB_new.db");
    
    return await openDatabase(
      dbPath,
      onCreate: (db, version) async{
        //create all tables here
        await db.execute(
          "CREATE TABLE $TABLE_NOTE ($COLUMN_NOTE_SNO INTEGER PRIMARY KEY AUTOINCREMENT,$COLUMN_NOTE_TITLE TEXT,$COLUMN_NOTE_DESC TEXT)"
        );
      },

      version: 5,
    );
  }

  ///<--all quires--->(CRUD)
  ///insertion
  Future<bool>addNote({required String mTitle,required String mDesc})async{
    var db=await _getDB();
    int rowEffected=await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE:mTitle,
      COLUMN_NOTE_DESC:mDesc,
    });

    return rowEffected>0;
  }

  ///reading all DATA
  Future<List<Map<String,dynamic>>> getNote()async{
    var db=await _getDB();

    List<Map<String,dynamic>>mData=await db.query(TABLE_NOTE);

    return mData;

  }

  //updating data
  Future<bool>updateNote({required String mTitle,required String mDesc,required int sno})async{
    var db=await _getDB();

    int rowEffected=await db.update(TABLE_NOTE, {
      COLUMN_NOTE_TITLE:mTitle,
      COLUMN_NOTE_DESC:mDesc,
    },where: "$COLUMN_NOTE_SNO=$sno");

    return rowEffected>0;
  }

  //deleting Data
  Future<bool>deleteNote({required int sno})async{
    var db=await _getDB();

    int rowEffected=await db.delete(TABLE_NOTE,where: "$COLUMN_NOTE_SNO = $sno");

    return rowEffected>0;
  }

}