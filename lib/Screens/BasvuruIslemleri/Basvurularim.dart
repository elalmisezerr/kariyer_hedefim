import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';

import '../../Models/Basvuru.dart';
import '../../Models/Ilan.dart';
import '../../Models/Kullanici.dart';
import '../GirisEkranı.dart';

class Basvurularim extends StatefulWidget {
  User? user;

  Basvurularim({Key? key, required this.user}) : super(key: key);

  @override
  State<Basvurularim> createState() => _BasvurularimState();
}

class _BasvurularimState extends State<Basvurularim> {
  var dbHelper = DatabaseProvider();

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
      drawer: MyDrawer(user: widget.user!),
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
          title: Text("Başvurularım"),
        ),
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assect/images/arkabir.png"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: FutureBuilder<List<Ilanlar>>(
            future: dbHelper.getIlanlarByKullaniciId(widget.user!.id.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Hata: ${snapshot.error}',
                    style: TextStyle(fontSize: 10),
                  ),
                );
              } else {
                final ilan = snapshot.data ?? [];
                if (ilan.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height*(0.3),),
                        Icon(Icons.folder_off_outlined,size: 40,color: Colors.red,),
                        Text('Başvuru bulunamadı!!',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red,
                        ),),
                      ],
                    ),
                  );
                } else {
                  return buildIlanList(ilan);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  ListView buildIlanList(final List<Ilanlar> ilanlar) {
    return ListView.builder(
      itemCount: ilanlar.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ilanlar[position].baslik,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Icon(Icons.explore),
                    SizedBox(width: 8.0),
                    Expanded(child: Text(convertJsonToQuillController(ilanlar[position].aciklama).document.toPlainText(),maxLines: 4,)),
                    IconButton(onPressed: () async {
                      var temp;
                      temp=await dbHelper.getBasvuruIdByIlanAndKullanici(ilanlar[position].id.toString(),widget.user!.id.toString() );
                      await dbHelper.deleteBasvuru(temp);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Basvurularim(user: widget.user)));
                    }, icon: Icon(Icons.delete,size: 30,color: Colors.red,))
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.business),
                    SizedBox(width: 8.0),
                    FutureBuilder<String?>(
                      future: sirketIsmiGetir(ilanlar[position].sirket_id.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text('Sirket yukleniyor...');
                        } else if (snapshot.hasError) {
                          return Text('Hata: ${snapshot.error}');
                        } else {
                          return Text(snapshot.data ?? '');
                        }
                      },
                    ),
                  ],
                ),
                /* Image.network(
                  jobImage,
                  height: 50.0,
                  width: 50.0,
                ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.monetization_on),
                SizedBox(width: 8.0),
                Text(jobSalary),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.work),
                SizedBox(width: 8.0),
                Text(jobType),
              ],
            ),*/
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
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



  Future<String?> sirketIsmiGetir(String sirketId) async {
    final result = await dbHelper.getCompanyById(int.parse(sirketId));
    return result?.isim;
  }

}
