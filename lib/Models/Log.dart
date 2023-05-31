import 'package:sqflite/sqflite.dart';

class LogModel {
  int? id;
  String kisi;
  String kull_id;
  String cevirimici;
  String islem;
  String tarih;

  LogModel({required this.id,required this.kisi,required this.kull_id,required this.cevirimici,required this.islem,required this.tarih});
  LogModel.withoutId({required this.kisi,required this.kull_id,required this.cevirimici,required this.islem,required this.tarih});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kisi': kisi,
      'kull_id': kull_id,
      'cevirimici': cevirimici,
      'islem': islem,
      'tarih': tarih,
    };
  }

  static LogModel fromMap(Map<String, dynamic> map) {
    return LogModel(
      id: map['id'],
      kisi: map['kisi'],
      kull_id: map['kull_id'],
      islem: map['islem'],
      cevirimici: map['cevirimici'],
      tarih: map['tarih'],
    );
  }

  static Future<List<LogModel>> getAllLogs(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('log');
    return List.generate(maps.length, (i) {
      return LogModel.fromMap(maps[i]);
    });
  }
}
