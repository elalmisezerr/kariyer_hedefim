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
  var txtTelefon = TextEditingController();
  var txtAdres = TextEditingController();
  var x = ValidationCompanyAddMixin();

  var emailError;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
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

  buildUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email adresinizi giriniz",
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
          validator: validateSurName,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.house),
          ),
          controller: txtAdres,
        )
      ],
    );
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
            addCompanies();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginCompany()));
            String email = 'szrelalmis@gmail.com';
            await dbHelper.checkIsAdmin(email);
          } else {
            _showResendDialog();
          }
        }else{
          print("Eksik bilgi!!");
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
      isim: txtName.text,
      email: txtuserName.text,
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
