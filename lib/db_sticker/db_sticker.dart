
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sticker/db_sticker/sticker_entity.dart';


class DBSticker extends GetxService {
  late Database dbBase;

  Future<DBSticker> init() async {
    await createStickerDB();
    return this;
  }

  createStickerDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'sticker.db');

    dbBase = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await createStickerTable(db);
        });
  }

  createStickerTable(Database db) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS sticker (id INTEGER PRIMARY KEY, createdTime TEXT, image BLOB)');
  }

  insertSticker(StickerEntity entity) async {
    final id = await dbBase.insert('sticker', {
      'createdTime': entity.createdTime.toIso8601String(),
      'image': entity.image,
    });
    return id;
  }

  deleteStickers(List<StickerEntity> entities) async {
    for (var entity in entities) {
      await dbBase.delete('sticker', where: 'id = ?', whereArgs: [entity.id]);
    }
  }

  cleanStickerData() async {
    await dbBase.delete('sticker');
  }

  Future<List<StickerEntity>> getStickerAllData() async {
    var result = await dbBase.query('sticker', orderBy: 'createdTime DESC');
    return result.map((e) => StickerEntity.fromJson(e)).toList();
  }
}
