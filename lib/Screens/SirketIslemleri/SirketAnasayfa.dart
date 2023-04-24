import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/JobAdvertisements.dart';
import 'package:kariyer_hedefim/Screens/IlanIslemleri/IlanDuzenle.dart';
import '../../Data/GoogleSignin.dart';
import '../../Models/Company.dart';
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
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  @override
  void initState() {
    setState(() {
    });
    super.initState();
  }

  String dateFormatterDMY(String date) {
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd-MM-yyyy');
    try {
      final dateTime = inputFormat.parse(date.replaceAll('/', '-'));
      final formattedDate = outputFormat.format(dateTime);
      return formattedDate;
    } catch (e) {
      print('Error parsing date: $date');
      return '';
    }
  } String dateFormatterYMD(String date) {
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



  void logout() {
    setState(() async{
      if(GoogleSignInApi!=null){
        await GoogleSignInApi.logout();
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GirisEkrani()));
    });

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
            title: Text("Çıkış yapmak istiyor musunuz?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("HAYIR"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("EVET"),
              ),
            ],
          );
        },
      );
      return exit ;
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
        drawer: MyDrawerComp(company: widget.company!,),
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
                    showSearch(context: context, delegate: DataSearch(widget.company!));
                  },
                  icon: Icon(Icons.search)),
              IconButton(onPressed: (){
                AlertDialog(
                  backgroundColor: Color(0xffbf1922),
                  title: Text("Çıkış yapmak istiyor musunuz?",style: TextStyle(
                      fontWeight: FontWeight.bold,color: Colors.white
                  ),),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("HAYIR",style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                    TextButton(
                      onPressed: () =>logout,
                      child: Text("EVET",style: TextStyle(
                        color: Colors.white,),
                      ),
                    )],
                );
              }, icon: Icon(Icons.logout))
            ],
          ),
          body: Container(
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
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>IlanDuzenleme(ilanlar: ilanlar[position], company: widget.company,)));
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
                      Icon(
                        Icons.bookmark_border,
                        size: 30.0,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 30.0,
                    child: Text(
                      ilanlar[position].aciklama,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Divider(height: 20, thickness: 1, color: Colors.grey),
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 5.0),
                      Text(checkJobTime(ilanlar[position].calisma_zamani.toString())??""),
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

}


class DataSearch extends SearchDelegate<String> {
  var dbHelper = DatabaseProvider();
  _HomeCompanyState? homeuser;
  DataSearch(this.company,);
  Company company;
  Ilanlar? selectedilanlar;
  String dateFormatterDMY(String date) {
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd-MM-yyyy');
    try {
      final dateTime = inputFormat.parse(date.replaceAll('/', '-'));
      final formattedDate = outputFormat.format(dateTime);
      return formattedDate;
    } catch (e) {
      print('Error parsing date: $date');
      return '';
    }
  } String dateFormatterYMD(String date) {
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
                print(selectedilanlar!.tarih);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                      IlanDuzenleme(ilanlar: selectedilanlar, company: company),
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
                          Text(selectedilanlar!.tarih,
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
                    selectedilanlar!.aciklama,
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
              : ilanlar.where((i) => i!.baslik.startsWith(query))
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
                selectedilanlar = ilanlar.firstWhere((i) => i!.baslik == suggestionsList[index]);
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

