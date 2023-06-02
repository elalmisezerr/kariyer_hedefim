import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Models/Kurum.dart';

import '../../Data/DbProvider.dart';
import '../GirisEkranı.dart';

class HomeAdmin extends StatefulWidget {
   HomeAdmin({ required Mycompany,Key? key,}) : super(key: key);
  Company? Mycompany;
  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  var dbHelper = DatabaseProvider();
  var formKey = GlobalKey<FormState>();
  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void logout() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GirisEkrani()));
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        bool exit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Önceki sayfaya dönmek istiyor musunuz?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("HAYIR"),
                ),
                TextButton(
                  onPressed: () {
                   logout();
                  },
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
        drawer: MyDrawerAdmin(),
          child: Scaffold(
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

              title: Text("Admin Anasayfa"),
              automaticallyImplyLeading: false,

              actions: <Widget>[
                /*IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: DataSearch(widget.company!));
                  },
                  icon: Icon(Icons.search)),*/
                IconButton(onPressed: () {
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

                }, icon: Icon(Icons.logout))
              ],
            ),
            body: Center(
              child: Text("Admin Sayfasına Hoşgeldiniz!!",style: TextStyle(
                  color: Color(0xffbf1922),
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),),
            ),
          ),
      ),
    );
  }
}
