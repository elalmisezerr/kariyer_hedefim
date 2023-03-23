import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/JobAdvertisements.dart';
import 'package:kariyer_hedefim/Screens/BasvuruIslemleri/BasvuruAnasayfa.dart';
import 'package:kariyer_hedefim/Screens/BasvuruIslemleri/BasvuruGoruntule.dart';
import 'package:kariyer_hedefim/Models/User.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/KullaniciDetay.dart';
import 'KullaniciEkle.dart';

class HomeUser extends StatefulWidget {
  User user;
  HomeUser({Key? key,required this.user}) : super(key: key);

  @override
  State<HomeUser> createState() => _HomeState();
}

class _HomeState extends State<HomeUser> {

  var dbHelper=DatabaseProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF355891),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: (){
_toggleDrawer();
          },
        ),
        title: const Text("Kullanıcı Anasayfa"),
        actions: <Widget>[
          IconButton(onPressed: logout, icon: const Icon(Icons.logout))
        ],
      ),
      drawer: createDrawer(),
      body:govde(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  const UsersAdd()),
          );
          if (result == true) {
            setState(() {});
          }
        },
        tooltip: "Yeni ürün ekle",
        child: const Icon(Icons.add),
      ),
    );
  }
  govde(){
    return Container(
      decoration: const BoxDecoration(
        image:  DecorationImage(
          image: AssetImage("assect/images/arkabir.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: FutureBuilder<List<Ilanlar>>(
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
    );
  }


  void _toggleDrawer() async {
    setState(() {
      _scaffoldKey.currentState!.openDrawer();
    });
  }createDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: const Color(0xFF355891),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Yönetim Paneli',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Profil Sayfası',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UserDetail( user: widget.user)));
              });
            },
          ),
          ListTile(
            title: const Text(
              'Başvurularım',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              setState(() {
                //yapılan başvurular görüntülenir
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BasvuruGoruntule(user: widget.user,),
                  ),
                );
              });
            },
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) => Colors.blueGrey,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Text(
                  'Üst Menüye Dön',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void logout() {
    setState(() {
      Navigator.pop(context);
    });
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
                  builder: (context) => BasvuruSayfasi(
                    user: widget.user,
                    ilanlar: ilanlar[position],
                  ),
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



}
