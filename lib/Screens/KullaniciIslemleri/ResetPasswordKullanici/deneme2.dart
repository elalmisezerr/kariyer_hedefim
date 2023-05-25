import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Models/Kullanici.dart';
import 'package:kariyer_hedefim/Screens/GirisEkran%C4%B1.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/GirisSirket.dart';
import 'package:kariyer_hedefim/Validation/ValidationCompanyAddMixin.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../../../Data/DbProvider.dart';
import 'Deneme.dart';

class ResetPasswordVerificationPageUser extends StatefulWidget {
  final String email;
  final String kod;

  ResetPasswordVerificationPageUser({required this.email, required this.kod});

  @override
  _ResetPasswordVerificationPageStateUser createState() =>
      _ResetPasswordVerificationPageStateUser();
}

class _ResetPasswordVerificationPageStateUser
    extends State<ResetPasswordVerificationPageUser> {
  TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Çıkış yapmak istiyor musunuz?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("HAYIR"),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginUser()),
                  ),
                  child: Text("EVET"),
                )
              ],
            );
          },
        );
        return exit;
      },
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Color(0xffbf1922),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ResetPasswordPageUser()));
            },
          ),
          title: Text('Şifre Sıfırlama'),
          automaticallyImplyLeading: false,

        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text(
                  'Lütfen aşağıya 6 haneli kodu girin',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 40.0),
                buildPassword2(),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                    'Devam',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      primary: Color(0xffbf1922)),
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.kod == codeController.text) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor:Color(0xffbf1922),
                                    title: Text(
                                      "Başarılı",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            "Kodunuz Doğrulandı Şifre Sıfırlayabilirsiniz.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PasswordRecover(email: widget.email,)));
                                        },
                                        child: const Text(
                                          "Tamam",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                            }
                          }
                        },
                ),
                SizedBox(height: 16.0),
                TextButton(
                  child: Text(
                    ' Şifre Sıfırlama E-postasını Tekrar Gönder',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xffbf1922),
                        fontWeight: FontWeight.normal),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          sendEmail();
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  buildPassword2() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
      child: TextFormField(
        maxLength: 6,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Kod zorunlu';
          } else if (value.length != 6) {
            return 'Kod 6 haneli olmalı';
          }
          return null;
        },
        controller: codeController,
        obscureText: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "12345",
            labelText: "Şifrenizi girin",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }
  void sendEmail() async {
    String username = 'szrelalmis@gmail.com'; // gönderen e-posta adresi
    String password = 'amilkijnegrbxuye'; // gönderen e-posta adresi şifresi
    final smtpServer = gmail(username, password);

    final random = Random();
    final resetCode = random
        .nextInt(1000000)
        .toString()
        .padLeft(6, '0'); // 6 haneli rastgele sayı oluştur

    final message = Message()
      ..from = Address(username, 'Şifre Sıfırlama Uygulaması')
      ..recipients.add(widget.email)
      ..subject = 'Şifre Sıfırlama İsteği'
      ..text =
          'Merhaba, şifrenizi sıfırlamak için aşağıdaki kodu kullanın: $resetCode'
      ..html =
          "<h1>Merhaba</h1>\n<p>Şifrenizi sıfırlamak için aşağıdaki kodu kullanın: <strong>$resetCode</strong></p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('E-posta gönderildi: ' + sendReport.toString());
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Color(0xffbf1922),
            title: Text(
              "Başarılı",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "Şifre sıfırlama bağlantısı gönderildi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordVerificationPageUser(
                            email: widget.email,
                            kod: resetCode,
                          )));
                },
                child: const Text(
                  "Tamam",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ));
    } on MailerException catch (e) {
      print('Hata: $e');
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Color(0xffbf1922),
            title: Text(
              "Hata",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "E-posta gönderilemedi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Tamam",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ));
    } catch (e) {
      print('Hata: $e');
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Color(0xffbf1922),
            title: Text(
              "Hata",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "Beklenmeyen bir hata oluştu",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Tamam",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ));
    }
  }
}

class PasswordRecover extends StatefulWidget {
  final String email;
    PasswordRecover({Key? key, required this.email}) : super(key: key);

  @override
  State<PasswordRecover> createState() => _PasswordRecoverState();
}

class _PasswordRecoverState extends State<PasswordRecover> with ValidationCompanyAddMixin {
  var txtpassWord = TextEditingController();
  var txtpassWord2 = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var dbHelper = DatabaseProvider();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor:Color(0xffbf1922),
              title: Text(
                "Güvenli Çıkış Yapın",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      "Çıkış yapmak istiyor musunuz?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    "HAYIR",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginUser()),
                  ),
                  child: const Text(
                    "EVET",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ));
        return exit;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffbf1922),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginUser()));
            },
          ),
          title: Text('Şifrenizi Sıfırlamayın'),
          automaticallyImplyLeading: false,
        ),
        body: Form(
          key: formKey,
          child: Center(
              child: ListView(
                children: [
                  SizedBox(height: 40,),buildPassword3(), buildPassword4(), SizedBox(height: 20,),buildSaveButton()],
              ),
          ),
        ),
      ),
    );
  }
  buildPassword3() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Kod zorunlu';
          } else if (value.length != 6) {
            return 'Kod 6 haneli olmalı';
          }
          return null;
        },
        controller: txtpassWord,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "12345",
            labelText: "Şifrenizi girin",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }
  buildPassword4() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Kod zorunlu';
          } else if (value.length != 6) {
            return 'Kod 6 haneli olmalı';
          }
          return null;
        },
        controller: txtpassWord2,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "12345",
            labelText: "Şifrenizi girin",
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
          if (formKey.currentState!.validate()){
            formKey.currentState!.save();
            var temp=await dbHelper.getUserByEmail(widget.email);
            if(txtpassWord.text==txtpassWord2.text){
              temp!.password=txtpassWord.text;
              await dbHelper.updateUser(temp);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginCompany()));
            }

          }
        },
        child: Text(
          "Şifreyi Güncelle",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: Color(0xffbf1922)),
      ),
    );
  }

}
