import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/JobApplications.dart';

import '../../Models/JobAdvertisements.dart';
import '../../Models/User.dart';

class BasvuruSayfasi extends StatefulWidget {
  User user;
  Ilanlar? ilanlar;
  BasvuruSayfasi({Key? key, required this.user, required this.ilanlar})
      : super(key: key);
  @override
  State<BasvuruSayfasi> createState() => _BasvuruSayfasiState();
}

class _BasvuruSayfasiState extends State<BasvuruSayfasi> {
  var dbHelper = DatabaseProvider();
  var tarihSimdi=DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ilanlar!.baslik),
      ),
      body: Center(
        child: ListView(
          children: [
            ElevatedButton(
                onPressed: () {
                  basvur();
                },
                child: Text("Başvur"))
          ],
        ),
      ),
    );
  }
  void basvur() async {
    var result = await dbHelper.insertBasvuru(Basvuru.withoutId(
        ilanId: widget.ilanlar!.id.toString(),
        kullaniciId: widget.user.id.toString(),
        basvuruTarihi:DateFormat('yyyy-MM-dd').parse(tarihSimdi),
    ));
    Navigator.pop(context, true);
  }
}
