import 'package:kariyer_hedefim/Models/Company.dart';
import 'package:kariyer_hedefim/Models/JobAdvertisements.dart';
import 'package:kariyer_hedefim/Models/JobApplications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import '../Models/User.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "etrade.db");
    var etradeDb = openDatabase(dbPath, version: 1, onCreate: createDb);
    return etradeDb;
  }

  void createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ad TEXT,
      soyad TEXT,
      dogumtarihi DATE,
      email TEXT,
      password TEXT,
      telefon TEXT,
      adres TEXT
    );
''');

    await db.execute(
        "CREATE TABLE sirketler (id INTEGER PRIMARY KEY AUTOINCREMENT,isim TEXT,email TEXT,sifre TEXT,telefon TEXT,adres TEXT);");
    await db.execute(
        "CREATE TABLE basvurular (id INTEGER PRIMARY KEY AUTOINCREMENT,ilan_id TEXT,kullanici_id TEXT,basvuru_tarihi TEXT,FOREIGN KEY (ilan_id) REFERENCES ilanlar(id),FOREIGN KEY (kullanici_id) REFERENCES kullanicilar(id));");
    await db.execute(
        "CREATE TABLE ilanlar (id INTEGER PRIMARY KEY AUTOINCREMENT,baslik TEXT,aciklama TEXT,sirket_id TEXT,tarih TEXT,FOREIGN KEY (sirket_id) REFERENCES sirketler(id));");
  }

  Future<List<User>> getUsers() async {
    Database? db = await this.db;
    var result = await db!.query("users");
    return List.generate(
      result.length,
      (index) {
        return User.fromObject(result[index]);
      },
    );
  }

  Future<List<Company>> getCompanies() async {
    Database? db = await this.db;
    var result = await db!.query("sirketler");
    return List.generate(
      result.length,
      (index) {
        return Company.fromObject(result[index]);
      },
    );
  }

  Future<List<Ilanlar>> getIlanlar() async {
    Database? db = await this.db;
    var result = await db!.query("ilanlar");
    return List.generate(
      result.length,
      (index) {
        return Ilanlar.fromObject(result[index]);
      },
    );
  }

  Future<int> insertUser(User user) async {
    Database? db = await this.db;
    var result = await db!.insert("users", user.toMap());
    return result;
  }

  Future<int> insertCompany(Company company) async {
    Database? db = await this.db;
    var result = await db!.insert("sirketler", company.toMap());
    return result;
  }
  Future<int> insertBasvuru(Basvuru basvuru) async {
    Database? db = await this.db;
    var result = await db!.insert("basvurular",basvuru.toMap() );
    return result;
  }

  Future<int> insertIlan(Ilanlar ilanlar) async {
    Database? db = await this.db;
    var result = await db!.insert("ilanlar", ilanlar.toMap());
    return result;
  }

  Future<int> deleteUser(int id) async {
    Database? db = await this.db;
    var result = await db!.rawDelete("delete from users where id=$id");
    return result;
  }

  Future<int> deleteCompany(int id) async {
    Database? db = await this.db;
    var result = await db!.rawDelete("delete from sirketler where id=$id");
    return result;
  }

  Future<int> deleteIlan(int id) async {
    Database? db = await this.db;
    var result = await db!.rawDelete("delete from ilanlar where id=$id");
    return result;
  }

  Future<int> updateUser(User user) async {
    Database? db = await this.db;
    var result = await db!
        .update("users", user.toMap(), where: "id=?", whereArgs: [user.id]);
    return result;
  }

  Future<int> updateCompany(Company company) async {
    Database? db = await this.db;
    var result = await db!.update("sirketler", company.toMap(),
        where: "id=?", whereArgs: [company.id]);
    return result;
  }

  Future<int> updateIlan(Ilanlar ilanlar) async {
    Database? db = await this.db;
    var result = await db!.update("ilanlar", ilanlar.toMap(),
        where: "id=?", whereArgs: [ilanlar.id]);
    return result;
  }

  Future<User?> checkUser(String email, String password) async {
    final db = await dbProvider.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result != null && result.isNotEmpty) {
      return User.fromObject(result.first);
    } else {
      return null;
    }
  }

  Future<Company?> checkCompany(String email, String password) async {
    final db = await dbProvider.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await db.query(
      'sirketler',
      where: 'email = ? AND sifre = ?',
      whereArgs: [email, password],
    );
    if (result != null && result.isNotEmpty) {
      return Company.fromObject(result.first);
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getBasvurularByKullaniciId(String kullaniciId) async {
    final db = await dbProvider.db;
    return await db!.query('basvurular', where: 'kullanici_id = ?', whereArgs: [kullaniciId]);
  }

}
