import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';
import 'package:kariyer_hedefim/Validation/ValidationUser.dart';
import 'package:intl/intl.dart';

import '../../Models/User.dart';

class UsersAdd extends StatefulWidget {
  const UsersAdd({Key? key}) : super(key: key);

  @override
  State<UsersAdd> createState() => _UsersAddState();
}

class _UsersAddState extends State<UsersAdd> with Useraddvalidationmixin {
  var formKey = GlobalKey<FormState>();
  var dbHelper = DatabaseProvider();
  var txtName = TextEditingController();
  var txtSurname = TextEditingController();
  var txtBirthDate = TextEditingController();
  var txtuserName = TextEditingController();
  var txtpassWord = TextEditingController();
  var txtTelefon = TextEditingController();
  var txtAdres = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Text("Kullanıcı ekleme sayfası"),
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
              buildSurname(),
              SizedBox(
                height: 5.0,
              ),
              buildBirthDate(),
              SizedBox(
                height: 5.0,
              ),
              buildUsername(),
              SizedBox(
                height: 5.0,
              ),
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

  buildName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Adınızı giriniz",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          validator: validateName,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          controller: txtName,
        )
      ],
    );
  }

  buildSurname() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Soyadınızı giriniz",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          validator: validateSurName,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          controller: txtSurname,
        )
      ],
    );
  }

  buildUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kullanıcı adı giriniz",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          controller: txtuserName,
          keyboardType: TextInputType.emailAddress,
        )
      ],
    );
  }

  buildBirthDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Doğum tarihinizi seçin",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          validator: validateBirtdate,
          readOnly: true,
          onTap: _showDatePicker,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.cake),
          ),
          controller: txtBirthDate, // değiştirildi
        )
      ],
    );
  }

  buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Şifrenizi girin",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          validator: validatePassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
          controller: txtpassWord,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        )
      ],
    );
  }

  buildTelefon() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Telefonunuzu girin",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          validator: validatePhoneNumber,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          controller: txtTelefon,
          keyboardType: TextInputType.phone,
        )
      ],
    );
  }

  buildAdres() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Adresinizi girin",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          validator: validateAdres,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.house),
          ),
          controller: txtAdres,
        )
      ],
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
          bool kullaniciVarMi = await dbHelper.kullaniciAdiKontrolEt(txtuserName.text) ;
          bool sirketVarmi= await dbHelper.sirketAdiKontrolEt(txtuserName.text);
          bool kayitVarmi= sirketVarmi || kullaniciVarMi;
          if (kayitVarmi == false) {
            addUsers();
            String email = 'szrelalmis@gmail.com';
            await dbHelper.checkIsAdmin(email);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginUser()), (route) => false);
          } else { if(sirketVarmi==true &&kullaniciVarMi==false){
            _showResendDialog();
          }
          if(sirketVarmi==false &&kullaniciVarMi==true){
            _showResendDialog2();
          }
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
  void _showResendDialogcheck() {
    AlertDialog alert = AlertDialog(
      title: Text("Uyarı"),
      content: Text("Kayıt Başarıyla Eklendi"),
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
      content: Text("Bu email şirket olarak kayıt yapmıştır"),
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
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  void addUsers() async {
    txtpassWord.text=hashPassword(txtpassWord.text);
    var result = await dbHelper.insertUser(User.withOutId(
      ad: txtName.text,
      soyad: txtSurname.text,
      dogumtarihi:txtBirthDate.text,
      email: txtuserName.text,
      password: txtpassWord.text,
      telefon: txtTelefon.text,
      adres: txtAdres.text,
    ));
    _showResendDialogcheck();
    Navigator.pop(context, true);
  }
}