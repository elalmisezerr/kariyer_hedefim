import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/GirisSirket.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../../Data/DbProvider.dart';
import 'deneme2.dart';


class ResetPasswordPageUser extends StatefulWidget {
  @override
  _ResetPasswordPageStateUser createState() => _ResetPasswordPageStateUser();
}

class _ResetPasswordPageStateUser extends State<ResetPasswordPageUser> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var dbHelper = DatabaseProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xffbf1922),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginCompany()));
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
              buildEmail(),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text(
                  "Gönder",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    primary: Color(0xffbf1922)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var temp= await dbHelper.kullaniciAdiKontrolEt(emailController.text);
                    if(temp){
                      sendEmail();
                    }else{
                      _showResendDialog();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  buildEmail() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'E-posta adresi zorunlu';
          }
          return null;
        },
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "example@example.com",
            labelText: "E-posta Adresi",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }

  void _showResendDialog() {
    AlertDialog alert = AlertDialog(
      title: Text("Uyarı"),
      content: Text("Bu Kullanıcı Kayıtlı Değil"),
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
  void sendEmail() async {
    String username = 'szrelalmis@gmail.com'; // gönderen e-posta adresi
    String password = 'amilkijnegrbxuye'; // gönderen e-posta adresi şifresi
    final smtpServer = gmail(username, password);


    final random = Random();
    final resetCode = random.nextInt(1000000).toString().padLeft(6, '0'); // 6 haneli rastgele sayı oluştur

    final message = Message()
      ..from = Address(username, 'Şifre Sıfırlama Uygulaması')
      ..recipients.add(emailController.text)
      ..subject = 'Şifre Sıfırlama İsteği'
      ..text = 'Merhaba, şifrenizi sıfırlamak için aşağıdaki kodu kullanın: $resetCode'
      ..html = "<h1>Merhaba</h1>\n<p>Şifrenizi sıfırlamak için aşağıdaki kodu kullanın: <strong>$resetCode</strong></p>";

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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPasswordVerificationPageUser(email: emailController.text,kod: resetCode,)));
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
  }}