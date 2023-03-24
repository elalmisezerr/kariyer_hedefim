import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/JobAdvertisements.dart';
import 'package:kariyer_hedefim/Screens/AdminIslemleri/AdminEkle.dart';
import 'package:kariyer_hedefim/Screens/AdminIslemleri/BasvurulanListesi.dart';
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

  ListView buildIlanList(final List<Ilanlar> ilanlar) {
    return ListView.builder(
      itemCount: ilanlar.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BasvuruListesi(),
                ),
              );
            },
            child: Container(
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
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: [
                        Row(
                            children: [
                              Icon(
                                Icons.category,
                                size: 19.0,
                                color: Colors.red,
                              ),
                            ]
                        ),
                        VerticalDivider(color: Colors.grey[600]),
                        Icon(
                          Icons.access_time,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          DateFormat('yyyy-MM-dd').format(
                            ilanlar[position].tarih,
                          ),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
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
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
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
