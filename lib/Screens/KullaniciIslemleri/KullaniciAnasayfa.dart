import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/JobAdvertisements.dart';
import 'package:kariyer_hedefim/Screens/GirisEkran%C4%B1.dart';
import 'package:kariyer_hedefim/Screens/IlanIslemleri/IlanDetay.dart';
import 'package:kariyer_hedefim/Models/User.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/KullaniciDetay.dart';
import 'package:kariyer_hedefim/Screens/BasvuruIslemleri/Basvurularim.dart';

class HomeUser extends StatefulWidget {
  User user;
  HomeUser({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeUser> createState() => _HomeState();
}

class _HomeState extends State<HomeUser> {
  var dbHelper = DatabaseProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.white,
      controller: _advancedDrawerController,
      animationCurve: Curves.elasticInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,

      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      drawer: MyDrawer(user:widget.user),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
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
          title: Text("Kullanıcı Anasayfa"),
          actions: <Widget>[
            IconButton(onPressed: logout, icon: Icon(Icons.logout))
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assect/images/userhome.jpg"),
              fit: BoxFit.fill,
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
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }


  void logout() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GirisEkrani()));
    });
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
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      IlanDetay(ilanlar: ilanlar[position], user: widget.user),
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black, Colors.blue],
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
                          DateFormat('yyyy-MM-dd').format(
                            ilanlar[position].tarih,
                          ),
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
        );
      },
    );
  }
}



/*

 govde() {
    return;
  }

  void _toggleDrawer() async {
    setState(() {
      _scaffoldKey.currentState!.openDrawer();
    });
  }

  createDrawer2() {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: Color(0xFF355891),
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text(
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
                //kullanıcı detay sayfası
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserDetail(
                              user: widget.user,
                            )));
              });
            },
          ),
          ListTile(
            title: Text(
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
                    builder: (context) => Basvurularim(
                      user: widget.user,
                    ),
                  ),
                );
              });
            },
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) => Color(0xFF355891),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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



 */
