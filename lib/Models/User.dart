import 'package:intl/intl.dart';

class User {
  int? id;
  String ad;
  String soyad;
  DateTime dogumtarihi;
  String email;
  String password;
  String telefon;
  String adres;

  User({this.id,required this.ad,required this.soyad,required this.dogumtarihi, required this.email, required this.password, required this.telefon, required this.adres});
  User.withOutId({required this.ad,required this.soyad,required this.dogumtarihi,required this.email, required this.password, required this.telefon, required this.adres});

  factory User.fromObject(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      ad: map['ad'] as String,
      soyad: map['soyad'] as String,
      dogumtarihi: DateFormat('dd-MM-yyyy').parse(map['dogumtarihi'] as String),
      email: map['email'] as String,
      password: map['password'] as String,
      telefon: map['telefon'] as String,
      adres: map['adres'] as String,
     );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "ad": ad,
      "soyad": soyad,
      "dogumtarihi": dogumtarihi.toString(),
      "email": email,
      "password": password,
      "telefon":telefon,
      "adres":adres,
    };
  }
}
