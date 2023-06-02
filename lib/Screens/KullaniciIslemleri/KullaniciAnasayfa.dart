import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/Ilan.dart';
import 'package:kariyer_hedefim/Screens/GirisEkran%C4%B1.dart';
import 'package:kariyer_hedefim/Screens/IlanIslemleri/IlanDetay.dart';
import 'package:kariyer_hedefim/Models/Kullanici.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';

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
        bool exit = await
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor:Color(0xffbf1922),
              title: Text(
                "Güvenli Çıkış Yapın",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      "Çıkış yapmak istiyor musunuz?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
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
                  child: const Text(
                    "EVET",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ));
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
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor:Color(0xffbf1922),
                          title: Text(
                            "Güvenli Çıkış Yapın",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                  "Çıkış yapmak istiyor musunuz?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text(
                                "HAYIR",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => logout(),
                              child: const Text(
                                "EVET",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ));
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          body:Container(
            child: FutureBuilder<List<Ilanlar>>(
              future: dbHelper.getIlanlar(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else {
                  final ilanlar = snapshot.data ?? [];
                  if (ilanlar.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height*(0.3),),
                          Icon(Icons.folder_off_outlined,size: 40,color: Colors.red,),
                          Text('İlan bulunmamaktadır!!',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.red,
                          ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return buildIlanList(ilanlar);
                  }
                }
              },
            ),
          )
          ,
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
  void logout() async {
      await dbHelper.updateUserLoggedInStatus(widget.Myuser!.email, false);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GirisEkrani()));
    logoutgoogle();
  }

  void logoutgoogle() {
    if (GoogleSignInApi != null) {
      GoogleSignInApi.logout();
    }
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
                  child: Image.asset(
                    'assect/images/jobsearch.jpg',
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
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
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.description,
                            size: 16.0, color: Colors.white),
                        SizedBox(width: 5.0),
                        SizedBox(height: 5.0),
                        Expanded(
                          child: Text(
                            convertJsonToQuillController(
                                ilanlar[position].aciklama)
                                .document
                                .toPlainText(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    )
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
    return QuillController
        .basic(); // Or throw an exception, depending on your requirements
  }

  var jsonMap = jsonDecode(jsonString);
  Document doc = Document.fromJson(jsonMap);
  QuillController controller = QuillController(
      document: doc,
      selection: TextSelection(
        baseOffset: 0,
        extentOffset: doc.length,
      ));
  return controller;
}




class DataSearch extends SearchDelegate<String> {
  var dbHelper = DatabaseProvider();
  _HomeState? homeuser;
  DataSearch(this.user);
  User user;
  Ilanlar? selectedilanlar;
  BuildContext? context;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
      IconButton(
        onPressed: () {
          showResults(context);
        },
        icon: Icon(Icons.search),
      ),
    ];
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
      ),
    );
  }

  Future<List<Ilanlar>> getilanlar() async {
    return await dbHelper.getIlanlar();
  }
  @override
  Widget buildResults(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return FutureBuilder<List<Ilanlar>>(
          future: getilanlar(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error Occurred'));
            } else {
              final ilanlar = snapshot.data!;
              final lowerCaseQuery = query.toLowerCase();
              final filteredList = ilanlar.where((ilan) {
                final baslik = ilan.baslik.toLowerCase();
                final aciklama = convertJsonToQuillController(ilan.aciklama).document.toPlainText().toLowerCase();
                return baslik.contains(lowerCaseQuery) || aciklama.contains(lowerCaseQuery);
              }).toList();

              if (filteredList.isEmpty) {
                return Center(child: Text('No results found.'));
              }

              return ListView(
                children: filteredList.map((ilan) {
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
                                ilanlar: ilan, user: user),
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
                            child:Image.asset(
                              'assect/images/jobsearch.jpg',
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                ilan.baslik,
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
                                    ilan.tarih,
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
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.description,
                                      size: 16.0, color: Colors.white),
                                  SizedBox(width: 5.0),
                                  SizedBox(height: 5.0),
                                  Expanded(
                                    child: Text(
                                      convertJsonToQuillController(
                                          ilan.aciklama)
                                          .document
                                          .toPlainText(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );

                }).toList(),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Ilanlar>>(
      future: getilanlar(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error Occurred'));
        } else {
          final ilanlar = snapshot.data!;
          final suggestionsList = query.isEmpty
              ? ilanlar
              : ilanlar.where((i) {
            final lowerCaseQuery = query.toLowerCase();
            final baslik = i.baslik.toLowerCase();
            final aciklama = convertJsonToQuillController(i.aciklama)
                .document
                .toPlainText()
                .toLowerCase();
            return baslik.contains(lowerCaseQuery) ||
                aciklama.contains(lowerCaseQuery);
          }).toList();
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.work_outline_sharp),
              title: RichText(
                text: TextSpan(
                  text: suggestionsList[index].baslik.substring(0, query.length),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: suggestionsList[index].baslik.substring(query.length),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

              ),
              onTap: () {
                selectedilanlar = suggestionsList[index];
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

