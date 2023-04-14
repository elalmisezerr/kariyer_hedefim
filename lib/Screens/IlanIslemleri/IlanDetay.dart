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
  var txtBody = TextEditingController();
  var txtSubject = TextEditingController();
  var txtRecipients = TextEditingController();
  late final Email email;
  @override
  void initState() {
    _companyFuture = dbHelper
        .getCompanyById(int.parse(widget.ilanlar!.sirket_id.toString()));
    email= Email(
      body: txtBody.text,
      subject: txtSubject.text,
      recipients: [txtRecipients.text],
      isHTML: false,
    );
    super.initState();
  }


  Future<void> sendEmail(File file) async {
    final company = await _companyFuture;
    print(company!.email);
    if (company != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İlan Detay"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildSubject(),
              buildBody(),
              buildRecipients(),
              ElevatedButton(
                child: Text('E-posta Gönder'),
                onPressed: () async {
                  await FlutterEmailSender.send(email);
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  bool basvuruVarmi = await dbHelper.basvuruKontrolEt(
                      widget.user!.id.toString(), widget.ilanlar!.id.toString());
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
        controller: txtBody,
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
        controller: txtSubject,
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
        controller: txtRecipients,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Gönderilecek Kişinin Emailini Girin!!",
            labelText: "Email",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }
}

