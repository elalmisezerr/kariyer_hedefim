import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kariyer_hedefim/Models/JobAdvertisements.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/KullaniciAnasayfa.dart';

import '../../Data/DbProvider.dart';
import '../../Models/Company.dart';
import '../../Models/JobApplications.dart';
import '../../Models/User.dart';

class IlanDetay extends StatefulWidget {
  Ilanlar? ilanlar;
  User? user;
  IlanDetay({Key? key, required this.ilanlar, required this.user})
      : super(key: key);

  @override
  State<IlanDetay> createState() => _IlanDetayState();
}

class _IlanDetayState extends State<IlanDetay> {
  var dbHelper = DatabaseProvider();
  Future<Company?>? _companyFuture;
  var email=TextEditingController();
  var body=TextEditingController();
  var subject=TextEditingController();
  sendEmail (String subject, String body, String recipientemail) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: [recipientemail],
// cc: ['cc@example.com'],
// bcc: ['bcc@example.com'],
// attachmentPaths: ['/path/to/attachment.zip'],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }

  final _key = GlobalKey<FormState>();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeUser(user: widget.user)), (route) => false);
          },
        ),
        title: Text("İlan Detay"),
        backgroundColor: Color(0xffbf1922),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildSubject(),
                buildBody(),
                buildRecipients(),
                ElevatedButton(
                  onPressed: () async {
                    bool basvuruVarmi = await dbHelper.basvuruKontrolEt(
                        widget.user!.id.toString(), widget.ilanlar!.id.toString());
                    _key.currentState!.save();
                    print('${email.text}');
                    sendEmail(subject.text, body.text, email.text);
                    if (basvuruVarmi == false) {
                      dbHelper.insertBasvuru(Basvuru.withoutId(
                        basvuruTarihi: DateTime.now(),
                        ilanId: widget.ilanlar!.id.toString(),
                        kullaniciId: widget.user!.id.toString(),
                      ));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeUser(user: widget.user)));
                    } else {
                      _showResendDialog();
                    }
                  },
                  child: Text("Başvur"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showResendDialog() {
    AlertDialog alert = AlertDialog(
      title: Text("Uyarı"),
      content: Text("Bu ilana zaten başvuru yapmışsınız!!!"),
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

  buildBody(){
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50,top: 30),
      child: TextField(
        maxLines: 3,
        controller: body,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Mailin içeriğini giriniz:",
            labelText: "Mail",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  } buildSubject(){
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50,top: 30),
      child: TextField(
        controller: subject,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Konu Giriniz",
            labelText: "Konu",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }buildRecipients(){
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50,top: 30,bottom: 20),
      child: TextField(
        controller: email,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Gönderilecek Emaili Girin!!",
            hintStyle: TextStyle(fontSize: 12),
            labelText: "Email",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }
}
