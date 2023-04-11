import 'package:intl/intl.dart';

class Ilanlar {
  int? id;
  String baslik;
  String aciklama;
  int? sirket_id;
  DateTime tarih;
  int calisma_zamani;
  Ilanlar(
      {this.id,
      required this.baslik,
      required this.aciklama,
      required this.sirket_id,
      required this.tarih,
      required this.calisma_zamani

      });
  Ilanlar.withOutId(
      {required this.baslik,
      required this.aciklama,
      required this.sirket_id,
      required this.tarih,
      required this.calisma_zamani

      });

  factory Ilanlar.fromObject(Map<String, dynamic> map) {
    return Ilanlar(
      id: map['id'] as int?,
      baslik: map['baslik'] as String,
      aciklama: map['aciklama'] as String,
      sirket_id: int.parse(map['sirket_id'].toString()),
      tarih: DateFormat('dd-MM-yyyy').parse(map['tarih'] as String),
      calisma_zamani: int.parse(map['calisma_zamani'].toString())
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "baslik": baslik,
      "aciklama": aciklama,
      "sirket_id": sirket_id,
      "tarih": tarih.toString(),
      "calisma_zamani": calisma_zamani

    };
  }
}
