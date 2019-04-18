import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:memo/vo/Memo.dart';


class DbProvider{

  // singleton pattern
  DbProvider._();
  static final DbProvider dbProviderInstance = DbProvider._();

  static Database _database; 
  Future<Database> get database async{
      if(_database != null) return _database;      

      _database = await _initDb();
      return _database;
  }

  _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "flutter_simple_memo.db");
    return await openDatabase(
      path, version: 2, onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Memo ("
            "id INTEGER PRIMARY KEY,"
            "title TEXT,"
            "contents TEXT,"
            "category TEXT,"
            "upd_date TEXT"
            ")");
    });  
  }

  Future<void> saveMemo(MemoVo memoVo) async{
    print("here:$memoVo");
    final db = await database;
    await db.rawInsert(
      "insert into memo (id, title, contents, upd_date, category)"
      "values ((select max(id)+1 from memo),'${memoVo.title}',"
              "'${memoVo.contents}','${memoVo.updDate}','${memoVo.category}')"
    );    
  }

  Future<List<MemoVo>> getMemoList() async{
    final db = await database;
    var rslt = await db.query("Memo");   
    return List.generate(rslt.length, (idx){
      return MemoVo(
        id: rslt[idx]["id"],
        title: rslt[idx]["title"],
        contents: rslt[idx]["contents"],
        category: rslt[idx]["category"],
        updDate: rslt[idx]["upd_date"],
      );
    });       
  }

  Future<void> removeMemo(int memoId) async{
    final db = await database;
    await db.rawDelete(
      "delete from memo where id = ?",
      [memoId]
    );
  }
}

