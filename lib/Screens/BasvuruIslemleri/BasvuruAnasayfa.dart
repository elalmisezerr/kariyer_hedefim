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
  var tarihSimdi = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ilanlar!.baslik),
      ),
      body: Center(
        child: ListView(
          children: [
            govde(),
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
  govde(){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assect/images/arkabir.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: FutureBuilder<List<dynamic>>(
        future: dbHelper.getKullanicilarByIlanlarId(widget.ilanlar!.id.toString()),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) { // updated type
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            final kullanicilar = snapshot.data?.cast<String>() ?? []; // cast to List<String>
            return buildKullaniciList(kullanicilar);
          }
        },
      ),
    );
  }
  void basvur() async {
    var result = await dbHelper.insertBasvuru(Basvuru.withoutId(
      ilanId: widget.ilanlar!.id.toString(),
      kullaniciId: widget.user.id.toString(),
      basvuruTarihi: DateFormat('dd-MM-yyyy').format(tarihSimdi as DateTime),
    ));
    Navigator.pop(context, true);
  }

  Widget buildKullaniciList(List kullanicilar) {
    return ListView(
      children: kullanicilar.map(
            (item) => Card(
          child: Column(
            children: [
              Text(item),
            ],
          ),
        ),
      ).toList(),
    );
  }
}
