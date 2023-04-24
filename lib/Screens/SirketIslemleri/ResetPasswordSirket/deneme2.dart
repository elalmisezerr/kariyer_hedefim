import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/GirisSirket.dart';
import 'package:kariyer_hedefim/Validation/ValidationCompanyAddMixin.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../../../Data/DbProvider.dart';
import 'Deneme.dart';

class ResetPasswordVerificationPage extends StatefulWidget {
  final String email;
  final String kod;

  ResetPasswordVerificationPage({required this.email, required this.kod});

  @override
  _ResetPasswordVerificationPageState createState() =>
      _ResetPasswordVerificationPageState();
}

class _ResetPasswordVerificationPageState
    extends State<ResetPasswordVerificationPage> {
  TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffbf1922),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResetPasswordPage()));
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
              Text(
                'Şifre sıfırlama kodu e-posta adresinize gönderildi.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              Text(
                'Lütfen aşağıya kodu girin:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'Şifre Sıfırlama Kodu',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Kod zorunlu';
                  } else if (value.length != 6) {
                    return 'Kod 6 haneli olmalı';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: _isLoading ? CircularProgressIndicator() : Text('Devam'),
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.kod == codeController.text) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Hata'),
                                      content: Text('Kodunuz Doğrulandı Şifre Sıfırlayabilirsiniz!!:)'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: Text('Tamam'),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PasswordRecover(email: widget.email,)));
                                          },
                                        ),
                                      ],
                                    ));
                          }
                        }
                      },
              ),
              SizedBox(height: 16.0),
              TextButton(
                child: Text('Şifre Sıfırlama E-postasını Tekrar Gönder'),
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
          title: Text('Başarılı'),
          content: Text('Şifre sıfırlama bağlantısı gönderildi'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordVerificationPage(
                              email: widget.email,
                              kod: resetCode,
                            )));
              },
            ),
          ],
        ),
      );
    } on MailerException catch (e) {
      print('Hata: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Hata'),
          content: Text('E-posta gönderilemedi'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } catch (e) {
      print('Hata: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Hata'),
          content: Text('Beklenmeyen bir hata oluştu'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Şifrenizi Değiştirin"),
      ),
      body: Form(
        key: formKey,
        child: Center(
            child: ListView(
              children: [
                buildPassword(),
                buildPassword2(),
                buildSaveButton()
              ],
            ),
        ),
      ),
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
  buildPassword2() {
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
          controller: txtpassWord2,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        )
      ],
    );
  }
  buildSaveButton(){
    return TextButton(onPressed: () async {
      if (formKey.currentState!.validate()){
        formKey.currentState!.save();
        var temp=await dbHelper.getCompanyByEmail(widget.email);
        if(txtpassWord.text==txtpassWord2.text){
          temp!.sifre=txtpassWord.text;
          await dbHelper.updateCompany(temp);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginCompany()));
        }

      }
    }, child: Text("Şifreyi güncelle"));
  }

}
