import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';
import 'package:kariyer_hedefim/Validation/ValidationUser.dart';

import '../../Data/DbProvider.dart';
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
        txtBirthDate.text =
            (DateFormat('dd-MM-yyyy').format(selectedDate)).toString();
      });
    }
  }

  buildSaveButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          bool kullaniciVarMi = await dbHelper.kullaniciAdiKontrolEt(widget.userr.email.toString())||await dbHelper.sirketAdiKontrolEt(widget.userr.email.toString());
          if (kullaniciVarMi == false) {
            addUsers();
            String email = 'szrelalmis@gmail.com';
            await dbHelper.checkIsAdmin(email);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginUser()));

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
      dogumtarihi:  DateTime.parse(dateFormatterYMD(txtBirthDate.text)),
      email: emaill,
      password: txtpassWord.text,
      telefon: txtTelefon.text,
      adres: txtAdres.text,
    ));
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginUser()));
  }
}
String dateFormatterDMY(String date) {
  final inputFormat = DateFormat('yyyy-MM-dd');
  final outputFormat = DateFormat('dd-MM-yyyy');
  try {
    final dateTime = inputFormat.parse(date.replaceAll('/', '-'));
    final formattedDate = outputFormat.format(dateTime);
    return formattedDate;
  } catch (e) {
    print('Error parsing date: $date');
    return '';
  }
} String dateFormatterYMD(String date) {
  final inputFormat = DateFormat('dd-MM-yyyy');
  final outputFormat = DateFormat('yyyy-MM-dd');
  try {
    final dateTime = inputFormat.parse(date.replaceAll('/', '-'));
    final formattedDate = outputFormat.format(dateTime);
    return formattedDate;
  } catch (e) {
    print('Error parsing date: $date');
    return '';
  }
}