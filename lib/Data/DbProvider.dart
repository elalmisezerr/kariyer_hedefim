import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Models/Kurum.dart';
import 'package:kariyer_hedefim/Models/Ilan.dart';
import 'package:kariyer_hedefim/Models/Basvuru.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../Models/Kullanici.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  //Create a new database
  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "kariyer.db");
    var etradeDb = openDatabase(dbPath, version: 1, onCreate: createDb);
    return etradeDb;
  }


  //Create Table
  void createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ad TEXT,
      soyad TEXT,
      dogumtarihi TEXT,
      email TEXT,
      password TEXT,
      telefon TEXT,
      adres TEXT,
      isLoggedIn INTEGER
    );
''');

    await db.execute(
        "CREATE TABLE sirketler (id INTEGER PRIMARY KEY AUTOINCREMENT,isim TEXT,email TEXT,sifre TEXT,telefon TEXT,adres TEXT,isLoggedIn INTEGER,isAdmin INTEGER DEFAULT 0);");
    await db.execute(
        "CREATE TABLE basvurular (id INTEGER PRIMARY KEY AUTOINCREMENT,ilan_id TEXT,kullanici_id TEXT,basvuru_tarihi TEXT,FOREIGN KEY (ilan_id) REFERENCES ilanlar(id) ON DELETE CASCADE,FOREIGN KEY (kullanici_id) REFERENCES users(id) ON DELETE CASCADE);");
    await db.execute(
        "CREATE TABLE ilanlar (id INTEGER PRIMARY KEY AUTOINCREMENT,baslik TEXT,aciklama TEXT,sirket_id TEXT,tarih TEXT,calisma_zamani INTEGER,FOREIGN KEY (sirket_id) REFERENCES sirketler(id) ON DELETE CASCADE);");
  }
  // Future insertInitialCompanyData(Database db) async {
  //   String email = 'szrelalmis@gmail.com';
  //   String password = hashPassword('Scerr4321');
  //   String ad = 'Sezer';
  //   String telefon = '5435659366';
  //   String adres = 'Ankara';
  //
  //
  //     Company company1=Company.withoutId(
  //       isim: ad,
  //       email: email,
  //       sifre: password,
  //       telefon: telefon,
  //       adres: adres,
  //     );
  //   await dbProvider.insertCompany(company1);
  //
  //   await dbProvider.isAdminUser(email);
  //
  // }


  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  //Get Methods
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
  Future<List<User>> getKullanicilarByIlanlarId(String ilanlarId) async {
    final db = await dbProvider.db;
    final result = await db!.rawQuery('''
      SELECT users.* 
      FROM users 
      JOIN basvurular ON users.id = basvurular.kullanici_id 
      WHERE basvurular.ilan_id = ?;
    ''', [ilanlarId]);
    return List.generate(
      result.length,
      (index) {
        return User.fromObject(result[index]);
      },
    );
  }
  Future<List<Ilanlar>> getIlanlarByKullaniciId(String userId) async {
    final db = await dbProvider.db;
    final result = await db!.rawQuery('''
      SELECT ilanlar.* 
      FROM ilanlar 
      JOIN basvurular ON ilanlar.id = basvurular.ilan_id 
      WHERE basvurular.kullanici_id = ?;
    ''', [userId]);
    return List.generate(
      result.length,
      (index) {
        return Ilanlar.fromObject(result[index]);
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
  Future<List<Ilanlar>> getIlanlarWithId(String id) async {
    Database? db = await this.db;
    var result = await db!.query("ilanlar", where: "sirket_id = '$id'");
    return List.generate(
      result.length,
      (index) {
        return Ilanlar.fromObject(result[index]);
      },
    );
  }

  Future<Company?> getCompanyById(int id) async {
    final db = await dbProvider.db;
    final result =
        await db!.query('sirketler', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Company.fromObject(result.first);
    } else {
      return null;
    }
  }

  Future<Company?> getCompanyByEmail(String mail) async {
    final db = await dbProvider.db;
    final result =
        await db!.query('sirketler', where: 'email = ?', whereArgs: [mail]);
    if (result.isNotEmpty) {
      return Company.fromObject(result.first);
    } else {
      return null;
    }
  }

  Future<User?> getUserByEmail(String mail) async {
    final db = await dbProvider.db;
    final result =
        await db!.query('users', where: 'email = ?', whereArgs: [mail]);
    if (result.isNotEmpty) {
      return User.fromObject(result.first);
    } else {
      return null;
    }
  }Future<int?> getBasvuruIdByIlanAndKullanici(String ilan,String kullanici) async {
    final db = await dbProvider.db;
    final result =
        await db!.query( 'basvurular',
          columns: ['id'],
          where: 'ilan_id = ? AND kullanici_id = ?',
          whereArgs: [ilan, kullanici],
          limit: 1,);
    if (result.isNotEmpty) {
      return result[0]['id'] as int;
    } else {
      return null;
    }
  }

  Future<bool> isAdminUser(String email) async {
    final db = await dbProvider.db;
    final result = await db!
        .rawQuery("SELECT isAdmin FROM sirketler WHERE email = ?", [email]);
    if (result.isNotEmpty) {
      return result.first["isAdmin"] == 1;
    } else {
      return false;
    }
  }

  //Insert Methods
  Future<int> insertUser(User user) async {
    Database? db = await this.db;
    try {
      var result = await db!.insert(
        "users",
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception("Aynı kayıt zaten mevcut.");
    }
  }

  Future<int> insertCompany(Company company) async {
    Database? db = await this.db;

    try {
      var result = await db!.insert(
        "sirketler",
        company.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception("Aynı kayıt zaten mevcut.");
    }
  }

  Future<int> insertBasvuru(Basvuru basvuru) async {
    Database? db = await this.db;
    try {
      var result = await db!.insert(
        "basvurular",
        basvuru.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception("Aynı kayıt zaten mevcut.");
    }
  }

  Future<int> insertIlan(Ilanlar ilanlar) async {
    Database? db = await this.db;
    try {
      var result = await db!.insert(
        "ilanlar",
        ilanlar.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw Exception("Aynı kayıt zaten mevcut.");
    }
  }

  //Delete Methods
  Future<int> deleteUser(int id) async {
    Database? db = await this.db;
    var result = await db!.rawDelete("delete from users where id=$id");
    return result;
  }

  Future<int> deleteCompany(int id) async {
    Database? db = await this.db;
    await db!.execute("DELETE FROM sirketler WHERE id = $id;");
    await db.execute("DELETE FROM ilanlar WHERE sirket_id = $id;");
    await db.execute(
        "DELETE FROM basvurular WHERE ilan_id IN (SELECT id FROM ilanlar WHERE sirket_id = $id);");
    int result = await db.rawUpdate("VACUUM"); // boş alanları temizleme
    return result;
  }

  Future<int> deleteIlan(int id) async {
    Database? db = await this.db;
    var result = await db!.rawDelete("delete from ilanlar where id=$id");
    return result;
  }

  Future<int> deleteBasvuru(int id) async {
    Database? db = await this.db;
    var result = await db!.rawDelete("delete from basvurular where id=$id");
    return result;
  }

  //Update Methods
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

  //Check Methods
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

  Future<void> checkIsAdmin(String email) async {
    Database? db = await this.db;
    await db!.transaction((txn) async {
      var res = await txn
          .rawQuery('SELECT * FROM sirketler WHERE email = ?', [email]);
      if (res.isNotEmpty) {
        int? sirketId = res.first['id'] as int?;
        await txn.rawUpdate(
            'UPDATE sirketler SET isAdmin = 1 WHERE email = ? AND id = ?',
            [email, sirketId]);
      }
    });
  }
  Future<bool> isAdmin(String email) async {
    Database? db = await this.db;
    var res = await db!.query('sirketler',
        columns: ['isAdmin'],
        where: 'email = ?',
        whereArgs: [email]);
    if (res.isNotEmpty) {
      return res.first['isAdmin'] == 1;
    }
    return false;
  }


  Future<String?> checkIfUsernameExists(String? username) async {
    Database db = await openDatabase('database.db');
    int? count = (await db.rawQuery(
        "SELECT COUNT(*) FROM users WHERE username = '$username'")) as int?;
    if (count! > 0) {
      return "Bu kullanıcı adı zaten mevcut";
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
  Future<void> updateUserLoggedInStatus(String email, bool isLoggedIn) async {
    Database? db = await this.db;
    await db!.update(
      'users',
      {'isLoggedIn': isLoggedIn ? 1 : 0},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<void> updateSirketLoggedInStatus(String email, bool isLoggedIn) async {
    Database? db = await this.db;
    await db!.update(
      'sirketler',
      {'isLoggedIn': isLoggedIn ? 1 : 0},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<User?> autoLoginUser() async {
    Database? db = await this.db;

    // Check if there is a user with isLoggedIn = 1
    var userRes = await db!.query('users',
        where: 'isLoggedIn = ?',
        whereArgs: [1],
        limit: 1);

    if (userRes.isNotEmpty) {
      // Found a user, set isLoggedIn to true and return user object
      var user = User.fromObject(userRes.first);
      user.isLoggedIn = true;
      await db.update('users', user.toMap(),
          where: 'id = ?', whereArgs: [user.id]);
      return user;
    }

    // No user found with isLoggedIn = 1
    return null;
  }

  Future<Company?> autoLoginCompany() async {
    Database? db = await this.db;

    // Check if there is a user with isLoggedIn = 1
    var compRes = await db!.query('sirketler',
        where: 'isLoggedIn = ?',
        whereArgs: [1],
        limit: 1);

    if (compRes.isNotEmpty) {
      // Found a user, set isLoggedIn to true and return user object
      var company = Company.fromObject(compRes.first);
      company.isLoggedIn = true;
      await db.update('sirketler', company.toMap(),
          where: 'id = ?', whereArgs: [company.id]);
      return company;
    }

    // No user found with isLoggedIn = 1
    return null;
  }

  Future<bool> basvuruKontrolEt(String userId, String ilanId) async {
    Database? db = await this.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await db.query(
      'basvurular',
      where: 'kullanici_id = ? AND ilan_id = ?',
      whereArgs: [userId, ilanId],
    );
    return result.isNotEmpty;
  }

  Future<bool> sirketAdiKontrolEt(String kullaniciAdi) async {
    Database? db = await this.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await db.query(
      'sirketler',
      where: 'email = ?',
      whereArgs: [kullaniciAdi],
    );
    return result.isNotEmpty;
  }
  Future<bool> kullaniciAdiKontrolEt(String kullaniciAdi) async {
    Database? db = await this.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [kullaniciAdi],
    );
    return result.isNotEmpty;
  }
}
