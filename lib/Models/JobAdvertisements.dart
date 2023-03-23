import 'package:intl/intl.dart';

class Ilanlar {
  int? id;
  String baslik;
  String aciklama;
  int? sirket_id;
  DateTime tarih;
  Ilanlar(
      {this.id,
      required this.baslik,
      required this.aciklama,
      required this.sirket_id,
      required this.tarih});
  Ilanlar.withOutId(
      {required this.baslik,
      required this.aciklama,
      required this.sirket_id,
      required this.tarih});

  factory Ilanlar.fromObject(Map<String, dynamic> map) {
    return Ilanlar(
      id: map['id'] as int?,
      baslik: map['baslik'] as String,
      aciklama: map['aciklama'] as String,
      sirket_id: int.parse(map['sirket_id'].toString()),
      tarih: DateFormat('yyyy-MM-dd').parse(map['tarih'] as String),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "baslik": baslik,
      "aciklama": aciklama,
      "sirket_id": sirket_id,
      "tarih": tarih.toString(),

    };
  }
}
