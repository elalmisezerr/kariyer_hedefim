import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kariyer_hedefim/Models/JobAdvertisements.dart';

import '../../Data/DbProvider.dart';
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

  Future<void> sendEmail(File file) async {
    final Email email = Email(
      body: 'CV attached',
      subject: 'Job Application',
      recipients: ['sezer12367.el@gmail.com'],
      attachmentPaths: [file.path],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print(error);
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
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  File file = File(result.files.single.path!);
                  await sendEmail(file);
                }
              },
              child: Text('Send Email'),
            ),

            ElevatedButton(
                onPressed: () {
                  dbHelper.insertBasvuru(Basvuru.withoutId(
                    basvuruTarihi: DateTime.now(),
                    ilanId: widget.ilanlar!.id.toString(),
                    kullaniciId: widget.user!.id.toString(),
                  ));
                },
                child: Text("Başvur"))
          ],
        ),
      ),
    );
  }
}
