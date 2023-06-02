import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/Ilan.dart';
import 'package:kariyer_hedefim/Screens/IlanIslemleri/IlanDuzenle.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/GirisSirket.dart';
import '../../Data/GoogleSignin.dart';
import '../../Models/Kurum.dart';
import '../../Models/Log.dart';
import '../GirisEkranı.dart';

class HomeCompany extends StatefulWidget {
  Company? company;
  bool isLoggedin = false;

  HomeCompany({Key? key, required this.company, required this.isLoggedin})
      : super(key: key);

  @override
  State<HomeCompany> createState() => _HomeCompanyState();
}

class _HomeCompanyState extends State<HomeCompany>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  var dbHelper = DatabaseProvider();
  final _advancedDrawerController = AdvancedDrawerController();
  QuillController? dene;
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
  LogModel? log;


  @override
  void initState() {
    setState(() {});
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
                  onPressed: () => Navigator.of(context).pop(true),

                  child: const Text(
                    "HAYIR",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginCompany()),
                            (route) => false);
                  },
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
        animationCurve: Curves.bounceInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,

        rtlOpening: false,
        // openScale: 1.0,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        drawer: MyDrawerComp(
          company: widget.company!,
        ),
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
            centerTitle: true,
            title: Text("Şirket Anasayfa"),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: DataSearch(widget.company!));
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
                icon: Icon(Icons.logout),
              )
            ],
          ),
          body:Container(
            child: Center(
              child: FutureBuilder<List<Ilanlar>>(
                future: dbHelper.getIlanlarWithId(widget.company!.id.toString()),
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
                    }

                    return buildIlanList(ilanlar);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListView buildIlanList(final List<Ilanlar> ilanlar) {
    return ListView.builder(
      itemCount: ilanlar.length,
      itemBuilder: (BuildContext context, int position) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IlanDuzenleme(
                          ilanlar: ilanlar[position],
                          company: widget.company,
                        )));
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ilanlar[position].baslik,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 35.0,
                    child: Expanded(
                      child: Text(
                        convertJsonToQuillController(ilanlar[position].aciklama)
                            .document
                            .toPlainText(),
                        style: TextStyle(fontSize: 16.0),
                        maxLines:3,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Divider(height: 20, thickness: 1, color: Colors.grey),
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 5.0),
                      Text(checkJobTime(
                              ilanlar[position].calisma_zamani.toString()) ??
                          ""),
                      SizedBox(width: 10.0),
                      Icon(Icons.layers),
                      SizedBox(width: 5.0),
                      Text(checkCalismasekli(
                          ilanlar[position].calisma_sekli.toString()) ??
                          ""),
                      SizedBox(width: 10.0),
                      Icon(Icons.date_range),
                      SizedBox(width: 5.0),
                      Text(ilanlar[position].tarih),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        ;
      },
    );
  }
  Future<String?> isLogedin(String x) async {
    var temp = await dbHelper.getSirketLoggedInStatus(x);
    print(await dbHelper.getSirketLoggedInStatus(x));
    if (temp == null) {
      return "";
    } else { // String değeri bool tipine dönüştürülüyor
      print(temp);
      if (temp) {
        return "Çevrimiçi";
      } else if (!temp) {
        return "Çevirim Dışı";
      } else {
        // "0" veya "1" dışında bir değer varsa buraya girer
        return "Bilinmeyen Durum";
      }
    }
  }

  Future<LogModel> logg(String islem, String mail) async {
    String? cevirimDurumu = await isLogedin(mail);
    if (widget.company != null) {
      widget.company = await dbHelper.getCompanyByEmail(mail);
    } else {
      // Handle the case where `company` is null
      // You can return an error LogModel or throw an exception
      throw Exception("Company is null");
    }
    log = LogModel.withoutId(
      kisi: "Kullanıcı:" + widget.company!.email,
      kull_id: widget.company!.id.toString(),
      cevirimici: cevirimDurumu!,
      islem: islem,
      tarih: DateTime.now().toString(),
    );
    return log!;
  }
  void logout() async {
    LogModel x=await logg("Kurumsal çıkış yapıldı",widget.company!.email);
    x.cevirimici="Çevirim Dışı";
    await dbHelper.insertLog(x);
    await dbHelper.updateSirketLoggedInStatus(widget.company!.email, false);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GirisEkrani()),
    );
    logoutgoogle();
  }


  void logoutgoogle() {
    if (GoogleSignInApi != null) {
      GoogleSignInApi.logout();
    }
  }

  String? checkJobTime(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value == '1') {
        return "Tam Zamanlı";
      } else if (value == '2') {
        return "Yarı Zamanlı";
      } else if (value == '3') {
        return "Her İkisi";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
  String? checkCalismasekli(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value == '1') {
        return "Online";
      } else if (value == '2') {
        return "Yüzyüze";
      } else if (value == '3') {
        return "Hibrit";
      } else {
        return null;
      }
    } else {
      return null;
    }
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
  _HomeCompanyState? homeuser;
  DataSearch(
      this.company,
      );
  Company company;
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
  String? checkCalismasekli(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value == '1') {
        return "Online";
      } else if (value == '2') {
        return "Yüzyüze";
      } else if (value == '3') {
        return "Hibrit";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  String? checkJobTime(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value == '1') {
        return "Tam Zamanlı";
      } else if (value == '2') {
        return "Yarı Zamanlı";
      } else if (value == '3') {
        return "Her İkisi";
      } else {
        return null;
      }
    } else {
      return null;
    }
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
    return await dbHelper.getIlanlarWithId(company.id.toString());
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
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IlanDuzenleme(company: company, ilanlar: ilan)),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ilan.baslik,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              height: 30.0,
                              child: Text(
                                convertJsonToQuillController(ilan.aciklama)
                                    .document
                                    .toPlainText(),
                                style: TextStyle(fontSize: 16.0),
                                maxLines: 3,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Divider(height: 20, thickness: 1, color: Colors.grey),
                            Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 5.0),
                                Text(checkJobTime(ilan.calisma_zamani.toString()) ?? ""),
                                SizedBox(width: 10.0),
                                Icon(Icons.layers),
                                SizedBox(width: 5.0),
                                Text(checkCalismasekli(
                                    ilan.calisma_sekli.toString()) ??
                                    ""),
                                SizedBox(width: 10.0),
                                Icon(Icons.date_range),
                                SizedBox(width: 5.0),
                                Text(ilan.tarih),
                              ],
                            ),
                          ],
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


