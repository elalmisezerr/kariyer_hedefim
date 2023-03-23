class Loginvalidationmixin {
  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Boş Geçilemez!';
    }
    try {
      if (value.length < 6) {
        return "İsim en az 6 karakter olmalıdır!";
      }
    } catch (e) {
      return 'Bir Email Giriniz!';
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Boş Geçilemez!';
    }
    try {
      if (value.length < 8 || value.length>17) {
        return "Şifre en az 8 ila 17 karakter uzunluğunda olmalıdır!";
      }
    } catch (e) {
      return 'Bir Şifre Giriniz!';
    }

  }

}
