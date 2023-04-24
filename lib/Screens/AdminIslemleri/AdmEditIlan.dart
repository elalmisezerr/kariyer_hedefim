import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Screens/IlanIslemleri/IlanDuzenle.dart';

import '../../Data/DbProvider.dart';
import '../../Data/GoogleSignin.dart';
import '../../Models/JobAdvertisements.dart';
import '../GirisEkranı.dart';
import '../IlanIslemleri/IlanDetay.dart';

class AdmEditIlan extends StatefulWidget {
  const AdmEditIlan({Key? key}) : super(key: key);

  @override
  State<AdmEditIlan> createState() => _AdmEditIlanState();
}

class _AdmEditIlanState extends State<AdmEditIlan> {
  var dbHelper = DatabaseProvider();
  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void logout() {
    setState(()  {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GirisEkrani()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.white,
      controller: _advancedDrawerController,
      animationCurve: Curves.bounceInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,

      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      drawer: MyDrawerAdmin(),
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Color(0xffbf1922),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
          centerTitle: true,

          title: Text("İlanlar"),
          automaticallyImplyLeading: false,

          actions: <Widget>[
            /*IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: DataSearch(widget.company!));
                  },
                  icon: Icon(Icons.search)),*/
            IconButton(onPressed: () async {
            logout();
            }, icon: Icon(Icons.logout))
          ],
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
                trailing: Icon(Icons.delete,size: 30,color: Colors.red,),
                onTap: () {
                  _showConfirmDeleteDialog(context, ilanlar[position]);
                },
              ),

            ),

          ),

        )
        ;
      },
    );
  }
  void _showConfirmDeleteDialog(BuildContext context, Ilanlar ilanlar) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kaydı Sil'),
          content: Text('Kaydı silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              child: Text('Hayır'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Evet'),
              onPressed: () {
                dbHelper.deleteIlan(ilanlar.id!); // Şirketi sil
                Navigator.of(context).pop();
                setState(() {}); // Liste güncelle
              },
            ),
          ],
        );
      },
    );
  }
  getCompanyById(int id) async {
    return await dbHelper.getCompanyById(id as int);
  }
}