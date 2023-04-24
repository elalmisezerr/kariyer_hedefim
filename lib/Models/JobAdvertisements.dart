import 'package:intl/intl.dart';

class Ilanlar {
  int? id;
  String baslik;
  String aciklama;
  int? sirket_id;
  String tarih;
  int calisma_zamani;
  //String kategori; // kategori özelliği eklendi
  Ilanlar(
      {this.id,
        required this.baslik,
        required this.aciklama,
        required this.sirket_id,
        required this.tarih,
        required this.calisma_zamani,
       // required this.kategori
      });

  Ilanlar.withOutId(
      {required this.baslik,
        required this.aciklama,
        required this.sirket_id,
        required this.tarih,
        required this.calisma_zamani,
        //required this.kategori
      });

  factory Ilanlar.fromObject(Map<String, dynamic> map) {
    return Ilanlar(
      id: map['id'] as int?,
      baslik: map['baslik'] as String,
      aciklama: map['aciklama'] as String,
      sirket_id: int.parse(map['sirket_id'].toString()),
      tarih: map['tarih'] as String,
      calisma_zamani: int.parse(map['calisma_zamani'].toString()),
     //kategori: map['kategori'] as String, // kategori özelliği eklendi
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "baslik": baslik,
      "aciklama": aciklama,
      "sirket_id": sirket_id,
      "tarih": tarih,
      "calisma_zamani": calisma_zamani,
      //"kategori": kategori // kategori özelliği eklendi
    };
  }
}
