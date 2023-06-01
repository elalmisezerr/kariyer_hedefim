import 'dart:typed_data';

class PdfModel {
  int? id;
  int? kullaniciId;
  Uint8List pdf;

  PdfModel({
    required this.id,
    required this.kullaniciId,
    required this.pdf,
  });
  PdfModel.withoutId({
    required this.kullaniciId,
    required this.pdf,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kullanici_id': kullaniciId,
      'pdf': pdf,
    };
  }

  static PdfModel fromMap(Map<String, dynamic> map) {
    return PdfModel(
      id: map['id'],
      kullaniciId: map['kullanici_id'],
      pdf: map['pdf'],
    );
  }
}
