class Company{
  int? id;
  String isim;
  String email;
  String sifre;
  String telefon;
  String adres;
  bool? isLoggedIn=false;
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  set isAdmin(bool value) {
    _isAdmin = value;
  }


  Company({this.id,required this.isim,required this.email,required this.sifre, required this.telefon, required this.adres});
  Company.withoutId({required this.isim,required this.email,required this.sifre, required this.telefon, required this.adres});
  factory Company.fromObject(Map<String, dynamic> map) {
    return Company(
      id: map['id'] as int?,
      isim: map['isim'] as String,
      email: map['email'] as String,
      sifre: map['sifre'] as String,
      telefon: map['telefon'] as String,
      adres: map['adres'] as String,
    )
      ..isLoggedIn = map['isLoggedIn'] == 1
      ..isAdmin = map['isAdmin'] == 1;

  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "isim": isim,
      "email": email,
      "sifre": sifre,
      "telefon":telefon,
      "adres":adres,
      "isLoggedIn": isLoggedIn! ? 1 : 0,
      "isAdmin": isAdmin ? 1 : 0,
    };
  }
}