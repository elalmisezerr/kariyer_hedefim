import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/JobAdvertisements.dart';
import 'package:kariyer_hedefim/Screens/IlanIslemleri/IlanDuzenle.dart';
import '../../Models/Company.dart';
import '../GirisEkranı.dart';

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

  String dateFormatter(String date) {
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd-MM-yyyy');
    final dateTime = inputFormat.parse(date);
    final formattedDate = outputFormat.format(dateTime);
    return formattedDate;
  }



  void logout() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GirisEkrani()));
    });
  }



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
            IconButton(onPressed: logout, icon: Icon(Icons.logout))
          ],
        ),
        body: Container(
          child: Center(
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
                      Text(dateFormatter(ilanlar[position].tarih.toString())),
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
    print(value);
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

