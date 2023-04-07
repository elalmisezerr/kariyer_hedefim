import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';

import '../../Models/JobAdvertisements.dart';
import '../../Models/User.dart';

class Basvurularim extends StatefulWidget {
  User? user;

  Basvurularim({Key? key, required this.user}) : super(key: key);

  @override
  State<Basvurularim> createState() => _BasvurularimState();
}

class _BasvurularimState extends State<Basvurularim> {
  var dbHelper = DatabaseProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Basvurularım"),
      ),
      drawer: MyDrawer(user:widget.user!),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assect/images/arkabir.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Ilanlar>>(
          future: dbHelper.getIlanlarByKullaniciId(widget.user!.id.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Hata: ${snapshot.error}',
                  style: TextStyle(fontSize: 10),
                ),
              );
            } else {
              final ilan = snapshot.data ?? [];
              return buildIlanList(ilan);
            }
          },
        ),
      ),
    );
  }

  ListView buildIlanList(final List<Ilanlar> ilanlar) {
    return ListView.builder(
      itemCount: ilanlar.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ilanlar[position].baslik,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Icon(Icons.explore),
                    SizedBox(width: 8.0),
                    Expanded(child: Text(ilanlar[position].aciklama)),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.business),
                    SizedBox(width: 8.0),
                    FutureBuilder<String?>(
                      future: sirketIsmiGetir(ilanlar[position].sirket_id.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text('Sirket yukleniyor...');
                        } else if (snapshot.hasError) {
                          return Text('Hata: ${snapshot.error}');
                        } else {
                          return Text(snapshot.data ?? '');
                        }
                      },
                    ),
                  ],
                ),
                /* Image.network(
                  jobImage,
                  height: 50.0,
                  width: 50.0,
                ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.monetization_on),
                SizedBox(width: 8.0),
                Text(jobSalary),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.work),
                SizedBox(width: 8.0),
                Text(jobType),
              ],
            ),*/
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> sirketIsmiGetir(String sirketId) async {
    final result = await dbHelper.getCompanyById(int.parse(sirketId));
    return result?.isim;
  }

}
