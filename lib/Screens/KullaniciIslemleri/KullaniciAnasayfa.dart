import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/Ilan.dart';
import 'package:kariyer_hedefim/Screens/GirisEkran%C4%B1.dart';
import 'package:kariyer_hedefim/Screens/IlanIslemleri/IlanDetay.dart';
import 'package:kariyer_hedefim/Models/Kullanici.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/KullaniciDetay.dart';
import 'package:kariyer_hedefim/Screens/BasvuruIslemleri/Basvurularim.dart';

import '../../Data/GoogleSignin.dart';

class HomeUser extends StatefulWidget {
  User? Myuser;
  HomeUser({Key? key, required this.Myuser}) : super(key: key);

  @override
  State<HomeUser> createState() => _HomeState();
}

String dateFormatter(DateTime date) {
  String formattedDate;
  return formattedDate =
      "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString()}";
}

class _HomeState extends State<HomeUser> {
  var dbHelper = DatabaseProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _advancedDrawerController = AdvancedDrawerController();
  User? _user;
  QuillController? ccontroller;

  @override
  void initState() {
    _user = widget.Myuser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xffbf1922),
              title: Text(
                "Çıkış yapmak istiyor musunuz?",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "HAYIR",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginUser()),
                      (route) => false),
                  child: Text(
                    "EVET",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            );
          },
        );
        return exit;
      },
      child: AdvancedDrawer(
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
        drawer: MyDrawer(user: _user!),
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
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: DataSearch(widget.Myuser!));
                  },
                  icon: Icon(Icons.search)),
              IconButton(
                  onPressed: () {
                    AlertDialog(
                      backgroundColor: Color(0xffbf1922),
                      title: Text(
                        "Çıkış yapmak istiyor musunuz?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            "HAYIR",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => logout,
                          child: Text(
                            "EVET",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          body: Container(
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
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void logout() {
    setState(() async {
      if (GoogleSignInApi != null) {
        await GoogleSignInApi.logout();
      }
      await dbHelper.updateUserLoggedInStatus(widget.Myuser!.email, false);
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
          color: Color(0xffbf1922),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IlanDetay(
                      ilanlar: ilanlar[position], user: widget.Myuser),
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffbf1922), Colors.red],
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
                    Divider(color: Colors.white),
                    SizedBox(height: 5.0),
                    Row(
                      children: [
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
                    SizedBox(height: 5.0),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Icon(Icons.description, size: 16.0, color: Colors.white),
                    SizedBox(width: 5.0),
                    Text(
                      convertJsonToQuillController(ilanlar[position].aciklama).document.toPlainText(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
QuillController convertJsonToQuillController(String jsonString) {
  if (jsonString.isEmpty) {
    // Handle the empty JSON string case
    return QuillController.basic(); // Or throw an exception, depending on your requirements
  }

  var jsonMap = jsonDecode(jsonString);
  Document doc = Document.fromJson(jsonMap);
  QuillController controller = QuillController(document: doc, selection: TextSelection(
    baseOffset: 0,
    extentOffset: doc.length,
  ));
  return controller;
}

class DataSearch extends SearchDelegate<String> {
  var dbHelper = DatabaseProvider();
  _HomeState? homeuser;
  DataSearch(
    this.user,
  );
  User user;
  Ilanlar? selectedilanlar;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () {}, icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, "");
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  Future<List<Ilanlar>> getilanlar() async {
    return await dbHelper.getIlanlar();
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Column(
        children: [
          Card(
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
                        IlanDetay(ilanlar: selectedilanlar, user: user),
                  ),
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.red, Colors.orange],
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
                        selectedilanlar!.baslik,
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
                            selectedilanlar!.tarih,
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
                   convertJsonToQuillController(selectedilanlar!.aciklama).document.toPlainText(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Ilanlar?>>(
      future: getilanlar(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error Occurred'));
        } else {
          final ilanlar = snapshot.data!;
          final suggestionsList = query.isEmpty
              ? ilanlar.map((i) => i!.baslik).toList()
              : ilanlar
                  .where((i) => i!.baslik.startsWith(query))
                  .map((i) => i!.baslik)
                  .toList();
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.work_outline_sharp),
              title: RichText(
                text: TextSpan(
                  text: suggestionsList[index].substring(0, query.length),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: suggestionsList[index].substring(query.length),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                selectedilanlar = ilanlar
                    .firstWhere((i) => i!.baslik == suggestionsList[index]);
                showResults(context);
              },
            ),
            itemCount: suggestionsList.length,
          );
        }
      },
    );
  }
}
