import 'package:kariyer_hedefim/Data/DbProvider.dart';

class ValidationCompanyAddMixin {
  var db = DatabaseProvider();
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Adınızı Giriniz!';
    }
    return null;
  }

  String? validateSurName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Soyadınızı Girin!';
    }
    return null;
  }

  String? validateBirtdate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Doğum Günü Boş Geçilemez!';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Lütfen şifrenizi girin';
    }
    if (value.length < 8) {
      return 'Şifre en az 6 karakter olmalıdır';
    }
    return null;
  }
  Future<bool> kullaniciAdiKontrolEt(String kullaniciAdi) async {
    final _db = await db.db;
    if (_db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await _db.query(
      'users',
      where: 'username = ?',
      whereArgs: [kullaniciAdi],
    );
    return result.isNotEmpty;
  }
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Boş Geçilemez!';
    }

      try {
        if (value.length < 6) {
          return 'Adres en az 6 karakter olmalıdır!';
        }
        // Perform additional validation here
        return null; // Return null if the value is valid
      } catch (e) {
        return 'Bir Email Giriniz!';
      }
  }

  String? validatePhoneNumber(String? value) {
    String pattern = r'^\d{10}$';
    RegExp regex = RegExp(pattern);
    if (value == null || !regex.hasMatch(value))
      return 'Lütfen Telefonunuzu Başında sıfır olmadan ve 10 hane olarak giriniz!!';
  }
}
