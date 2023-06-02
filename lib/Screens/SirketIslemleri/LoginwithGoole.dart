import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../Data/DbProvider.dart';
import '../../Data/GoogleSignin.dart';
import '../../Models/Kurum.dart';
import '../../Models/Log.dart';
import 'GirisSirket.dart';

class LoginGooleCompany extends StatefulWidget {
  final GoogleSignInAccount user;
  LoginGooleCompany({Key? key, required this.user}) : super(key: key);

  @override
  State<LoginGooleCompany> createState() => _LoginGooleCompanyState();
}

class _LoginGooleCompanyState extends State<LoginGooleCompany> {
  Company? company;
  var formKey = GlobalKey<FormState>();
  var dbHelper = DatabaseProvider();
  var txtpassWord = TextEditingController();
  var txtTelefon = TextEditingController();
  var txtAdres = TextEditingController();
  bool _isObscured = true;
  late final String fullName;
  late final String firstName;
  late final String email;
  LogModel? log;


  @override
  void initState() {
    fullName = widget.user.displayName ?? '';
    firstName = fullName.split(' ').first;
    email = widget.user.email.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xffbf1922),
              title: Text(
                "Önceki sayfaya dönmek istiyor musunuz?",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "HAYIR",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginCompany()),
                        (route) => false);
                    GoogleSignInApi.logout();
                  },
                  child: Text(
                    "EVET",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
        return exit;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffbf1922),
          title: Text("Google Kayıt Sayfası"),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: ListView(
              children: [
                buildPassword(),
                SizedBox(
                  height: 5.0,
                ),
                buildTelefon(),
                SizedBox(
                  height: 5.0,
                ),
                buildAdres(),
                SizedBox(
                  height: 5.0,
                ),
                buildSaveButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildPassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: TextField(
        controller: txtpassWord,
        obscureText: _isObscured,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          hintText: "Şifre Giriniz",
          labelText: "Şifre",
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          ),
        ),
        cursorColor: Colors.yellow,
      ),
    );
  }

  buildTelefon2() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: TextField(
        controller: txtTelefon,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Telefon Numarınızı Giriniz",
            labelText: "Telefon",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }
  buildTelefon() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: "Telefon Numarasını Giriniz",
                        labelText: "Telefon",
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          // burada numarayı aldığınızda yapılması gereken işlemleri yapabilirsiniz
                        },
                        onSaved: (PhoneNumber? number) {
                          txtTelefon.text = number?.phoneNumber ?? '';
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                          showFlags: true,
                        ),
                        ignoreBlank: true,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(
                            color: Colors.black, fontFamily: 'Comic Neue'),
                        initialValue: PhoneNumber(isoCode: 'TR'),
                        formatInput: true,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        maxLength: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  buildAdres() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
      child: TextField(
        maxLines: 3,
        maxLength: 30,
        controller: txtAdres,
        keyboardType: TextInputType.streetAddress,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.home),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Adresinizi Giriniz",
            labelText: "Adres",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }

  Future<String?> isLogedin(String x) async {
    var temp = await dbHelper.getSirketLoggedInStatus(x);
    print(await dbHelper.getSirketLoggedInStatus(x));
    if (temp == null) {
      return "";
    } else {
      bool isLoggedIn = "${temp}".toLowerCase() == 'true'; // String değeri bool tipine dönüştürülüyor
      print(temp);
      if (temp) {
        return "Çevrimiçi";
      } else if (!temp) {
        return "Çevirim Dışı";
      } else {
        // "0" veya "1" dışında bir değer varsa buraya girer
        return "Bilinmeyen Durum";
      }
    }
  }

  Future<LogModel> logg(String islem, String mail) async {
    String? cevirimDurumu = await isLogedin(mail);
    if (company != null) {
      company = await dbHelper.getCompanyByEmail(mail);
    } else {
      // Handle the case where `company` is null
      // You can return an error LogModel or throw an exception
      throw Exception("Company is null");
    }
    log = LogModel.withoutId(
      kisi: "Kullanıcı:" + company!.email,
      kull_id: company!.id.toString(),
      cevirimici: cevirimDurumu!,
      islem: islem,
      tarih: DateTime.now().toString(),
    );
    return log!;
  }


  buildSaveButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          bool kullaniciVarMi = await dbHelper
                  .kullaniciAdiKontrolEt(widget.user.email.toString()) ||
              await dbHelper.sirketAdiKontrolEt(widget.user.email.toString());
          if (kullaniciVarMi == false) {
            addCompanies();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginCompany()));
            String email = 'szrelalmis@gmail.com';
            await dbHelper.checkIsAdmin(email);
          } else {
            _showResendDialog();
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2),
          ],
          color: Color(0xffbf1922),
        ),
        child: Text(
          "Ekle",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  void addCompanies() async {
    var result = await dbHelper.insertCompany(Company.withoutId(
      isim: firstName,
      email: email,
      sifre: txtpassWord.text,
      telefon: txtTelefon.text,
      adres: txtAdres.text,
    ));

    // if (result == 1) {
    //   Navigator.pop(context, true);
    // } else {
    //   _showResendDialog();
    // }
  }

  void _showResendDialog() {
    AlertDialog alert = AlertDialog(
      title: Text("Uyarı"),
      content: Text("Bu Kullanıcı Zaten Mevcut"),
      actions: [
        ElevatedButton(
          child: Text("Tamam"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
