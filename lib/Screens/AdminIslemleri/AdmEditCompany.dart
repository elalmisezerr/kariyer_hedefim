import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Models/Kurum.dart';

import '../../Data/DbProvider.dart';
import '../../Data/GoogleSignin.dart';
import '../GirisEkranı.dart';

class AdmEditCompany extends StatefulWidget {
  const AdmEditCompany({Key? key}) : super(key: key);

  @override
  State<AdmEditCompany> createState() => _AdmEditCompanyState();
}

class _AdmEditCompanyState extends State<AdmEditCompany> {
  var dbHelper = DatabaseProvider();
  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void logout() {
    setState(() async {
      await GoogleSignInApi.logout();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GirisEkrani()));
    });
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

          title: Text("Şirketler"),
          automaticallyImplyLeading: false,

          actions: <Widget>[
            /*IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: DataSearch(widget.company!));
                  },
                  icon: Icon(Icons.search)),*/
            IconButton(onPressed: () async {
            logout();
            }, icon: Icon(Icons.logout))
          ],
        ),
        body: Container(
          child: FutureBuilder<List<Company>>(
            future: dbHelper.getCompanies(),
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
                final companies = snapshot.data ?? [];
                return buildUserList(companies);
              }
            },
          ),
        ),
      ),
    );
  }

  ListView buildUserList(final List<Company> company) {
    return ListView.builder(
      itemCount: company.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/512/146/146877.png?w=826&t=st=1680174675~exp=1680175275~hmac=0cf57b40d3b8182f9a40914db3ced05391c22e3eeb992057cb74d8fd9c0d9a3d',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company[position].isim,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 19.0,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        company[position].email,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 19.0,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        company[position].telefon,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Icon(
                        Icons.home,
                        size: 19.0,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        company[position].adres,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(Icons.delete,size: 30,color: Colors.red,),
              onTap: () {
                _showConfirmDeleteDialog(context, company[position]);
              },
            ),
          ),
        );
      },
    );
  }

  void _showConfirmDeleteDialog(BuildContext context, Company company) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kaydı Sil'),
          content: Text('Kaydı silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              child: Text('Hayır'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Evet'),
              onPressed: () {
                dbHelper.deleteCompany(company.id!); // Şirketi sil
                Navigator.of(context).pop();
                setState(() {}); // Liste güncelle
              },
            ),
          ],
        );
      },
    );
  }
}
