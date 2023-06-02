import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:sqflite/sqflite.dart';

import '../../Components/MyDrawer.dart';
import '../../Data/DbProvider.dart';
import '../../Models/Log.dart';
import '../GirisEkranı.dart';

class LogListPage extends StatefulWidget {
  const LogListPage();

  @override
  _LogListPageState createState() => _LogListPageState();
}

class _LogListPageState extends State<LogListPage> {
  List<LogModel> logs = [];
  Future<Database?> database = DatabaseProvider().db;
  var dbHelper = DatabaseProvider();
  final _advancedDrawerController = AdvancedDrawerController();
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

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    final Database? db = await database;
    if (db != null) {
      final List<LogModel> fetchedLogs = await LogModel.getAllLogs(db);
      setState(() {
        logs = fetchedLogs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
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
            title: Text("Log Listeleme"),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              /*IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: DataSearch(widget.company!));
                  },
                  icon: Icon(Icons.search)),*/
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor: Color(0xffbf1922),
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
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
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
          body: logs.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (0.3),
                      ),
                      Icon(
                        Icons.folder_off_outlined,
                        size: 40,
                        color: Colors.red,
                      ),
                      Text(
                        'Görüntülenecek log kaydı bulunmamaktadır!!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(log.kisi),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.circle,
                                    size: 10, color: Colors.black),
                                const SizedBox(width: 8),
                                Text('Kullanıcı ID: ${log.kull_id}'),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.circle,
                                    size: 10, color: Colors.black),
                                const SizedBox(width: 8),
                                Text('İşlem: ${log.islem}'),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.circle,
                                    size: 10, color: Colors.black),
                                const SizedBox(width: 8),
                                Text('Tarih: ${log.tarih}'),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            // Silme işlemini gerçekleştir
                            // Örnek olarak:
                            await dbHelper.deleteLog(logs[index].id!);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogListPage()));
                          },
                        ),
                      ),
                    );
                  },
                ),
        ));
  }

  Future<bool?> status(String email) async {
    bool? loggedInStatus = await dbHelper.getUserLoggedInStatus(email);
    bool? sirketLoggedInStatus = await dbHelper.getSirketLoggedInStatus(email);
    bool temp = loggedInStatus ?? false || sirketLoggedInStatus! ?? false;
    return temp;
  }

}
