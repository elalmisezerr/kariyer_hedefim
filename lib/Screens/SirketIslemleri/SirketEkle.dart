import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/Kurum.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/GirisSirket.dart';
import '../../Validation/ValidationCompanyAddMixin.dart';

class CompanyAdd extends StatefulWidget {
  const CompanyAdd({Key? key}) : super(key: key);

  @override
  State<CompanyAdd> createState() => _CompanyAddState();
}

class _CompanyAddState extends State<CompanyAdd>
    with ValidationCompanyAddMixin {
  var formKey = GlobalKey<FormState>();
  var dbHelper = DatabaseProvider();
  var txtName = TextEditingController();
  var txtuserName = TextEditingController();
  var txtpassWord = TextEditingController();
  var txtpassWord2 = TextEditingController();
  var txtTelefon = TextEditingController();
  var txtAdres = TextEditingController();
  var x = ValidationCompanyAddMixin();
  bool _isObscured = true;

  var emailError;
  @override
  void initState() {
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Color(0xffbf1922),
              title: Text(
                "Uygulamadan çıkmak istiyor musunuz?",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "HAYIR",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xffbf1922)),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginCompany()));
                  },
                  child: Text(
                    "EVET",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xffbf1922)),
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
          title: Text("Şirket ekleme sayfası"),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: ListView(
              children: [
                buildName(),
                SizedBox(
                  height: 5.0,
                ),
                buildEmail(),
                SizedBox(
                  height: 5.0,
                ),
                buildPassword(),
                SizedBox(
                  height: 5.0,
                ),
                buildPassword2(),
                SizedBox(
                  height: 5.0,
                ),
                buildTelefon(),
                SizedBox(
                  height: 5.0,
                ),
                buildAdres(),
                SizedBox(
                  height: 20,
                ),
                buildSaveButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: TextField(
        controller: txtName,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Adınızı Giriniz",
            labelText: "Ad",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }

  buildEmail() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: TextField(
        controller: txtuserName,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Email Giriniz",
            labelText: "Email",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }

  buildPassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
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

  buildPassword2() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextField(
        controller: txtpassWord2,
        obscureText: _isObscured,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          hintText: "Şifrenizi Tekrar Giriniz",
          labelText: "Şifre Tekrarı",
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
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
    return  Padding(
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
                        selectorTextStyle:
                        TextStyle(color: Colors.black, fontFamily: 'Comic Neue'),
                        initialValue: PhoneNumber(isoCode: 'TR'),
                        formatInput: true,
                        keyboardType:
                        TextInputType.numberWithOptions(signed: true, decimal: true),
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

  buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: ElevatedButton(
        onPressed: () async {
          if (txtpassWord.text == txtpassWord2.text) {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              bool kullaniciVarMi = await dbHelper.kullaniciAdiKontrolEt(txtuserName.text);
              bool sirketVarmi = await dbHelper.sirketAdiKontrolEt(txtuserName.text);
              bool kayitVarmi = sirketVarmi || kullaniciVarMi;
              if (kayitVarmi == false) {
                addCompanies();
                String email = 'szrelalmis@gmail.com';
                await dbHelper.checkIsAdmin(email);
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginCompany()));
              } else {
                if (sirketVarmi == true && kullaniciVarMi == false) {
                  _showResendDialog();
                } else if (sirketVarmi == false && kullaniciVarMi == true) {
                  _showResendDialog2();
                }
              }
            } else {
              print("Eksik bilgi!!");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Invalid login credentials.'),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Color(0xffbf1922),
                content: Text(
                  'Şifreler uyuşmuyor!!!.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },

        child: Text(
          "Ekle",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          primary: Color(0xffbf1922)),
      ),
    );
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void addCompanies() async {
    var result = await dbHelper.insertCompany(Company.withoutId(
      isim: txtName.text,
      email: txtuserName.text,
      sifre: hashPassword(txtpassWord.text),
      telefon: txtTelefon.text,
      adres: txtAdres.text,
    ));

    if (result == 1) {
      Navigator.pop(context, true);
    } else {
      _showResendDialog();
    }
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

  void _showResendDialog2() {
    AlertDialog alert = AlertDialog(
      title: Text("Uyarı"),
      content: Text("Bu email kullanıcı olarak kayıt yapmıştır"),
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
