import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';
import 'package:kariyer_hedefim/Validation/ValidationUser.dart';
import 'package:intl/intl.dart';

import '../../Components/Phoneformat.dart';
import '../../Models/Kullanici.dart';

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
  var txtpassWord2 = TextEditingController();
  var txtTelefon = TextEditingController();
  var txtAdres = TextEditingController();
  DateTime? _selectedDate;
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffbf1922),
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
                height: 20.0,
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
        SizedBox(
          height: 5,
        ),
        TextFormField(
          validator: validateName,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: "Adınızı Giriniz",
              labelText: "Ad",
              filled: true,
              fillColor: Colors.white),
          controller: txtName,
        )
      ],
    );
  }

  buildSurname() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.0),
        TextFormField(
          validator: validateSurName,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: "Soyadınızı Giriniz",
              labelText: "Soyad",
              filled: true,
              fillColor: Colors.white),
          controller: txtSurname,
        )
      ],
    );
  }

  buildUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.0),
        TextFormField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: "Email Giriniz",
              labelText: "Email",
              filled: true,
              fillColor: Colors.white),
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
        SizedBox(height: 5.0),
        TextFormField(
          validator: validateBirtdate,
          readOnly: true,
          onTap: _showDatePicker,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.cake),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: "Doğum Tarihinizi Seçiniz",
              labelText: "Doğum Tarihi",
              filled: true,
              fillColor: Colors.white),
          controller: txtBirthDate, // değiştirildi
        )
      ],
    );
  }

  buildPasswordold() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.0),
        TextFormField(
          validator: validatePassword,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.home),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: "Şifrenizi Giriniz",
              labelText: "Şifre",
              filled: true,
              fillColor: Colors.white),
          controller: txtpassWord,
          obscureText: _isObscured,
          keyboardType: TextInputType.visiblePassword,
        )
      ],
    );
  }

  buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.0),
        TextField(
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
      ],
    );
  }

  buildPassword2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        TextField(
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
      ],
    );
  }

  buildTelefon2() {
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

  buildTelefon() {
    return Column(
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
    );
  }

  buildAdres() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.0),
        TextFormField(
          validator: validateAdres,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.house),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: "Adresinizi Giriniz",
              labelText: "Adres",
              filled: true,
              fillColor: Colors.white),
          controller: txtAdres,
        )
      ],
    );
  }


  Future<void> _showDatePicker() async {
    final ThemeData datePickerTheme = ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(
        primary:Color(0xffbf1922), // Set the primary color to red
        onPrimary: Colors.white,
      ),
    );

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: datePickerTheme,
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        txtBirthDate.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: ElevatedButton(
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
                addUsers();
                String email = 'szrelalmis@gmail.com';
                await dbHelper.checkIsAdmin(email);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginUser()),
                        (route) => false);
              } else {
                if (sirketVarmi == true && kullaniciVarMi == false) {
                  _showResendDialog();
                }
                if (sirketVarmi == false && kullaniciVarMi == true) {
                  _showResendDialog2();
                }
              }
            }
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Color(0xffbf1922),
                  content: Text('Şifreler uyuşmuyor!!!.',textAlign: TextAlign.center,),

                ));
          }
          },
        child: Text(
          "Ekle",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: Color(0xffbf1922)),
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
    var result = await dbHelper.insertUser(User.withOutId(
      ad: txtName.text,
      soyad: txtSurname.text,
      dogumtarihi: txtBirthDate.text,
      email: txtuserName.text,
      password: hashPassword(txtpassWord.text),
      telefon: txtTelefon.text,
      adres: txtAdres.text,
    ));
    _showResendDialogcheck();
    Navigator.pop(context, true);
  }
}
