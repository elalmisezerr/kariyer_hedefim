import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/KullaniciAnasayfa.dart';
import 'package:kariyer_hedefim/Validation/ValidationUser.dart';

import '../../Data/DbProvider.dart';
import '../../Data/GoogleSignin.dart';
import '../../Models/User.dart';

class LoginGoogleUsers extends StatefulWidget {
  final GoogleSignInAccount userr;
  LoginGoogleUsers({Key? key, required this.userr}) : super(key: key);

  @override
  State<LoginGoogleUsers> createState() => _LoginGoogleUsersState();
}

class _LoginGoogleUsersState extends State<LoginGoogleUsers>
    with Useraddvalidationmixin {
  User? user;
  var formKey = GlobalKey<FormState>();
  var dbHelper = DatabaseProvider();
  var txtpassWord = TextEditingController();
  var txtTelefon = TextEditingController();
  var txtAdres = TextEditingController();
  var txtBirthDate = TextEditingController();

  bool _isObscured = true;
  late final String fullName;
  late final String firstName;
  late final String lastName;
  late final String emaill;

  @override
  void initState() {
    fullName = widget.userr.displayName ?? '';
    firstName = fullName.split(' ').first;
    lastName = fullName.split(' ').last;
    emaill = widget.userr.email.toString();
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
                        MaterialPageRoute(builder: (context) => LoginUser()),
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
                buildBirthDate(),
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

  Widget buildBirthDate() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: TextField(
        onTap: _showDatePicker,
        controller: txtBirthDate,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.cake),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Doğum Tarihini Giriniz",
            labelText: "Doğum Tarihi",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
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

  buildTelefon() {
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

  buildAdres() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
      child: TextField(
        maxLines: 3,
        maxLength: 40,
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

  Future<void> _showDatePicker() async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2025));
    if (selectedDate != null) {
      setState(() {
        txtBirthDate.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  buildSaveButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          bool kullaniciVarMi = await dbHelper
              .kullaniciAdiKontrolEt(widget.userr.email.toString());
          if (kullaniciVarMi == false) {
            addUsers();
            String email = 'szrelalmis@gmail.com';
            await dbHelper.checkIsAdmin(email);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginUser()));
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

  void addUsers() async {
    var result = await dbHelper.insertUser(User.withOutId(
      ad: firstName.toString(),
      soyad: lastName.toString(),
      dogumtarihi: txtBirthDate.text,
      email: emaill,
      password: txtpassWord.text,
      telefon: txtTelefon.text,
      adres: txtAdres.text,
    ));
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginUser()));
  }
}
