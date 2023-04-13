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

  @override
  void initState() {
    _companyFuture =
        dbHelper.getCompanyById(int.parse(widget.ilanlar!.sirket_id.toString()));
    super.initState();
  }
  final Email email = Email(
    body: 'CV attached',
    subject: 'Job Application',
    recipients: ['sezer12367.el@gmail.com'],
    isHTML: false,
  );
  Future<void> sendEmail(File file) async {
    final company = await _companyFuture;
    print(company!.email);
    if (company != null) {
     

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İlan Detay"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text('E-posta Gönder'),
              onPressed: () async {
                await FlutterEmailSender.send(email);
              },
            ),
            ElevatedButton(
              onPressed: () async {

                bool basvuruVarmi =await dbHelper.basvuruKontrolEt(widget.user!.id.toString(), widget.ilanlar!.id.toString());
                if (basvuruVarmi == false) {
                  dbHelper.insertBasvuru(Basvuru.withoutId(
                    basvuruTarihi: DateTime.now(),
                    ilanId: widget.ilanlar!.id.toString(),
                    kullaniciId: widget.user!.id.toString(),
                  ));
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => HomeUser(user: widget.user)));
                } else {
                  _showResendDialog();
                }

              },
              child: Text("Başvur"),
            ),

          ],
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
}



//final company = await _companyFuture;
// if (company != null) {
//   FilePickerResult? result = await FilePicker.platform.pickFiles();
//   if (result != null) {
//     File file = File(result.files.single.path!);
//     final Email email = Email(
//       body: 'CV attached',
//       subject: 'Job Application',
//       recipients: [company.email],
//       attachmentPaths: [file.path],
//       isHTML: false,
//     );
//     try {
//       await FlutterEmailSender.send(email);
//     } catch (error) {
//       print(error);
//     }
//   }
// }