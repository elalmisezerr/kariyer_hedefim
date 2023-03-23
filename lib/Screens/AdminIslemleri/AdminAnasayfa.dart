import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/JobAdvertisements.dart';
import 'package:kariyer_hedefim/Screens/AdminIslemleri/AdminEkle.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/KullaniciEkle.dart';
import 'package:kariyer_hedefim/models/User.dart';

import '../../Models/Company.dart';
import '../IlanIslemleri/İlanEkleme.dart';

class HomeAdmin extends StatefulWidget {
  Company? company;
  bool isLoggedin = false;

  HomeAdmin({Key? key, required this.company, required this.isLoggedin})
      : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  var dbHelper = DatabaseProvider();

  void _toggleDrawer() async {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      _scaffoldKey.currentState!.openDrawer();
    });
  }

  void logout() {
    setState(() {
      Navigator.pop(context);
      widget.isLoggedin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _toggleDrawer,
        ),
        title: Text("Şirket Anasayfa"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade700,
        actions: <Widget>[
          IconButton(onPressed: logout, icon: Icon(Icons.logout))
        ],
      ),
      drawer: createDrawer(),
      drawerEnableOpenDragGesture: false,
      body: Container(
        decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/images/background_image.jpg'),
    fit: BoxFit.cover
        )),
        child: Center(
          child: govde(),
        ),
      ),
    );
  }

  govde() {
    return FutureBuilder<List<Ilanlar>>(
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
    );
  }

  ListView buildIlanList(List<Ilanlar> ilanlar) {
    return ListView.builder(
        itemCount: ilanlar.length,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.black38,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black12,
                child: Text("p"),
              ),
              title: Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ilanlar[position].baslik,style: TextStyle(color: Colors.white)),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(DateFormat('yyyy-MM-dd').format(
                    ilanlar[position].tarih,
                  ),
                  style: TextStyle(fontSize: 14,color: Colors.white),),
                ],
              )),
              subtitle: Text(ilanlar[position].aciklama,style: TextStyle(color: Colors.white)),
              onTap: () {
                // goDetail(users[position]);
              },
            ),
          );
        });
  }

  createDrawer() {
    return InkWell(
      onTap: _toggleDrawer,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
              ),
              child: Text(
                'Yönetim Paneli',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('İlan Ekleme Sayfası'),
              onTap: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              IlanEkle(company: widget.company)));
                });
              },
            ),
            ListTile(
              title: const Text('Başvurular'),
              onTap: () {
                setState(() {
                  _isDrawerOpen = false;
                });
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      child: Center(
                        child: Text('Item 2 açılır paneli'),
                      ),
                    );
                  },
                );
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) => Colors.grey.shade700,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Üst Menüye Dön'),
            ),
          ],
        ),
      ),
    );
  }
}
