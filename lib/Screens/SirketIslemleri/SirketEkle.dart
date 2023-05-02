import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/Company.dart';
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
                side: BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
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

  buildTelefon() {
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
    return TextButton(
      onPressed: () async {
        if(txtpassWord.text==txtpassWord2.text){
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            bool kullaniciVarMi =
            await dbHelper.kullaniciAdiKontrolEt(txtuserName.text);
            bool sirketVarmi =
            await dbHelper.sirketAdiKontrolEt(txtuserName.text);
            bool kayitVarmi = sirketVarmi || kullaniciVarMi;
            if (kayitVarmi == false) {
              addCompanies();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginCompany()));
              String email = 'szrelalmis@gmail.com';
              await dbHelper.checkIsAdmin(email);
            } else {
              if (sirketVarmi == true && kullaniciVarMi == false) {
                _showResendDialog();
              }
              if (sirketVarmi == false && kullaniciVarMi == true) {
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

        }else{
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Color(0xffbf1922),
                content: Text('Şifreler uyuşmuyor!!!.',textAlign: TextAlign.center,),

              ));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
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
