
import 'package:flutter/material.dart';
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
