import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:kariyer_hedefim/Models/Ilan.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/KullaniciAnasayfa.dart';

import '../../Data/DbProvider.dart';
import '../../Models/Kurum.dart';
import '../../Models/Basvuru.dart';
import '../../Models/Kullanici.dart';

class IlanDetay extends StatefulWidget {
  Ilanlar? ilanlar;
  User? user;
  IlanDetay({Key? key, required this.ilanlar, required this.user})
      : super(key: key);

  @override
  State<IlanDetay> createState() => _IlanDetayState();
}

class _IlanDetayState extends State<IlanDetay> {
  QuillController _controller = QuillController.basic();
  bool showFullDescription = false;
  final _key = GlobalKey<FormState>();
  var dbHelper = DatabaseProvider();
  var email = TextEditingController();
  var body = TextEditingController();
  var subject = TextEditingController();

  @override
  void initState() {
    _controller = convertJsonToQuillController(widget.ilanlar!.aciklama);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeUser(Myuser: widget.user)),
                (route) => false);
          },
        ),
        title: Text("Başvuru Sayfası"),
        backgroundColor: Color(0xffbf1922),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _key,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.ilanlar!.baslik.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 16.0),
                    if (!showFullDescription)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _controller.document.toPlainText(),
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    showFullDescription = true;
                                  });
                                },
                                child: Text(
                                  'Daha Fazla Gör',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xffbf1922),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                    if (showFullDescription)
                      Container(
                        child: Column(
                          children: [
                            QuillEditor(
                              controller: _controller,
                              focusNode: FocusNode(),
                              scrollController: ScrollController(),
                              readOnly: true,
                              padding: EdgeInsets.all(4.0),
                              autoFocus: false,
                              expands: false,
                              scrollable: true,
                              showCursor: false,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showFullDescription = false;
                                });
                              },
                              child: Text(
                                'Küçült',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xffbf1922)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        bool basvuruVarmi = await dbHelper.basvuruKontrolEt(
                            widget.user!.id.toString(),
                            widget.ilanlar!.id.toString());
                        _key.currentState!.save();
                        if (basvuruVarmi == false) {
                          sendEmail(subject.text, body.text, email.text);
                          dbHelper.insertBasvuru(Basvuru.withoutId(
                            basvuruTarihi: DateTime.now().toString(),
                            ilanId: widget.ilanlar!.id.toString(),
                            kullaniciId: widget.user!.id.toString(),
                          ));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeUser(Myuser: widget.user)));
                        } else {
                          _showResendDialog();
                        }
                      },
                      child: Text(
                        "Başvur",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xffbf1922)),
                    ),
                  ],
                ),
              ),
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

  buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
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
  }

  buildSubject() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
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
  }

  buildRecipients() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 20),
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

  String dateFormatter(DateTime date) {
    String formattedDate;
    return formattedDate =
        "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString()}";
  }

  QuillController convertJsonToQuillController(String jsonString) {
    var jsonMap = jsonDecode(jsonString);
    Document doc = Document.fromJson(jsonMap);
    QuillController controller = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
    return controller;
  }


  sendEmail(String subject, String body, String recipientemail) async {
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
}
