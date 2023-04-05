class IlanValidationMixin{
  String? validateBaslik(String? value){
    if(value  == null || value.length == 0){
      return "Bir Basşlık Giriniz";
    }
    return null;
  }
  String? validateAciklama(String? value){
    if(value  == null || value.length == 0){
      return "Aciklama Giriniz";
    }
    return null;
  }
  String? validateTarih(String? value){
    if(value  == null || value.length == 0){
      return "Giriniz";
    }
    return null;
  }
}