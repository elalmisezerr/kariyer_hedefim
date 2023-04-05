import '../Data/DbProvider.dart';

class Useraddvalidationmixin{
  var dbHelper = DatabaseProvider();

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
  String? validateEmail(String? value) {
    if(dbHelper.checkIfUsernameExists(value)!=null){
      return 'Bu kullanıcı adı alınmıştır.';
    }else{
      if (value == null || value.isEmpty) {
        return 'Boş Geçilemez!';
      }
      RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(value)) {
        // E-posta adresi geçersiz
        return 'Lütfen geçerli bir e-posta adresi girin';
      }
    }
    // Geçerli e-posta adresi
    return null;
  }
  String? validatePassword(String? value){
    if (value!.isEmpty) {
      return 'Lütfen şifrenizi girin';
    }
    if (value.length < 8) {
      return 'Şifre en az 6 karakter olmalıdır';
    }
    return null;
  }
  String? validatePhoneNumber(String? value) {
    String pattern = r'^\d{10}$';
    RegExp regex = RegExp(pattern);
    if (value == null || !regex.hasMatch(value))
      return 'Lütfen Telefonunuzu Başında sıfır olmadan ve 10 hane olarak giriniz!!';

  }
  String? validateAdres(String? value) {
    if (value == null || value.isEmpty) {
      return 'Boş Geçilemez!';
    }
    try {
      if (value.length < 6) {
        return "Adres en az 6 karakter olmalıdır!";
      }
    } catch (e) {
      return 'Bir Email Giriniz!';
    }
  }


}