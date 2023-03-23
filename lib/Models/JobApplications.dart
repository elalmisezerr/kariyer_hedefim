import 'package:intl/intl.dart';

class Basvuru {
  int? id;
  String ilanId;
  String kullaniciId;
  DateTime basvuruTarihi;

  Basvuru({
    required this.id,
    required this.ilanId,
    required this.kullaniciId,
    required this.basvuruTarihi,
  });
  Basvuru.withoutId({
    required this.ilanId,
    required this.kullaniciId,
    required this.basvuruTarihi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ilan_id': ilanId,
      'kullanici_id': kullaniciId,
      'basvuru_tarihi': basvuruTarihi.toString(),
    };
  }

  static Basvuru fromMap(Map<String, dynamic> map) {
    return Basvuru(
      id: map['id'],
      ilanId: map['ilan_id'],
      kullaniciId: map['kullanici_id'],
      basvuruTarihi:DateFormat('yyyy-MM-dd').parse(map['basvuruTarihi'] as String),
    );
  }
}
