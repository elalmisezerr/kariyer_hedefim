import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Screens/IlanIslemleri/IlanDuzenle.dart';

import '../../Data/DbProvider.dart';
import '../../Models/JobAdvertisements.dart';
import '../IlanIslemleri/IlanDetay.dart';

class AdmEditIlan extends StatefulWidget {
  const AdmEditIlan({Key? key}) : super(key: key);

  @override
  State<AdmEditIlan> createState() => _AdmEditIlanState();
}

class _AdmEditIlanState extends State<AdmEditIlan> {
  var dbHelper = DatabaseProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ilanlar"),
      ),
      body: Container(
        child:FutureBuilder<List<Ilanlar>>(
          future: dbHelper.getIlanlar(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            } else {
              final ilanlar = snapshot.data ?? [];
              return buildIlanList(ilanlar);
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
          clipBehavior: Clip.antiAlias,
          elevation: 8.0,
          shadowColor: Colors.amber,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Color(0xffbf1922),
          child: GestureDetector(
            onTap: () {
              var temp=getCompanyById(ilanlar[position].sirket_id!);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context)  =>
                      IlanDuzenleme(company:temp,ilanlar:ilanlar[position] ),
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.network(
                    'https://img.freepik.com/free-vector/hiring-process_23-2148642176.jpg?w=826&t=st=1679557821~exp=1679558421~hmac=4d5df907230cd7727dfe0cd2aab440d3c1f6d192152521b83d90f489de2a564d',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ilanlar[position].baslik,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: [
                        Row(children: [
                          Icon(
                            Icons.category,
                            size: 19.0,
                            color: Colors.red,
                          ),
                        ]),
                        VerticalDivider(color: Colors.white),
                        Icon(
                          Icons.access_time,
                          size: 16.0,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          ilanlar[position].tarih,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: Text(
                  ilanlar[position].aciklama,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        )
        ;
      },
    );
  }
  getCompanyById(int id) async {
    return await dbHelper.getCompanyById(id as int);
  }
}
String dateFormatterDMY(String date) {
  final inputFormat = DateFormat('yyyy-MM-dd');
  final outputFormat = DateFormat('dd-MM-yyyy');
  try {
    final dateTime = inputFormat.parse(date.replaceAll('-', '-'));
    final formattedDate = outputFormat.format(dateTime);
    return formattedDate;
  } catch (e) {
    print('Error parsing date: $date');
    return '';
  }
}
String dateFormatter(DateTime date) {
  String formattedDate;
  return formattedDate= "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString()}";
}
String dateFormatterYMD(String date) {
  final inputFormat = DateFormat('dd-MM-yyyy');
  final outputFormat = DateFormat('yyyy-MM-dd');
  try {
    final dateTime = inputFormat.parse(date.replaceAll('/', '-'));
    final formattedDate = outputFormat.format(dateTime);
    return formattedDate;
  } catch (e) {
    print('Error parsing date: $date');
    return '';
  }
}
