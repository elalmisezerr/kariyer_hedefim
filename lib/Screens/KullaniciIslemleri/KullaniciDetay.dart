import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Validation/ValidationUser.dart';

import '../../Data/DbProvider.dart';
import '../../Models/User.dart';

class UserDetail extends StatefulWidget {
  User? user;
  UserDetail({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> with Useraddvalidationmixin {
  var formKey = GlobalKey<FormState>();
  var dbHelper = DatabaseProvider();
  var txtName = TextEditingController();
  var txtSurname = TextEditingController();
  var txtBirthDate = TextEditingController();
  var txtuserName = TextEditingController();
  var txtpassWord = TextEditingController();
  var txtTelefon = TextEditingController();
  var txtAdres = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    txtName.text = widget.user!.ad;
    txtSurname.text = widget.user!.soyad;
    txtBirthDate.text = widget.user!.dogumtarihi.toString();
    txtuserName.text = widget.user!.soyad;
    txtpassWord.text = widget.user!.password;
    txtTelefon.text = widget.user!.telefon;
    txtAdres.text = widget.user!.adres;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Profil Sayfasına Hoşgeldiniz"),
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
          validator: validateEmail,
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
            (DateFormat('yyyy-MM-dd').format(selectedDate)).toString();
      });
    }
  }

  buildSaveButton() {
    return TextButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
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
}
