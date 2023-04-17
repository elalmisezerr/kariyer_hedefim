import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Data/DbProvider.dart';
import '../../Models/Company.dart';
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
  @override
  void initState() {

    fullName = widget.user.displayName ?? '';
    firstName = fullName.split(' ').first;
    email=widget.user.email.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }


  buildPassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
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

  buildTelefon() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
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
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
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
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          bool kullaniciVarMi = await dbHelper.kullaniciAdiKontrolEt(widget.user.email.toString());
          if (kullaniciVarMi == false) {
            addCompanies();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginCompany()));
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
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2),
          ],
          color: Colors.grey.shade700,
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
