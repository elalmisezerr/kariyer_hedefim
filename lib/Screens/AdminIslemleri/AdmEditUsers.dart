import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';

import '../../Data/DbProvider.dart';
import '../../Models/Kullanici.dart';
import '../GirisEkranı.dart';

class AdmEditUsers extends StatefulWidget {
  const AdmEditUsers({Key? key}) : super(key: key);

  @override
  State<AdmEditUsers> createState() => _AdmEditUsersState();
}

class _AdmEditUsersState extends State<AdmEditUsers> {
  var dbHelper = DatabaseProvider();
  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void logout() {
    setState(() async {
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
        appBar:AppBar(
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

          title: Text("Kullanıcılar"),
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
        body: Container(
          child:FutureBuilder<List<User>>(
            future: dbHelper.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Hata: ${snapshot.error}',style: TextStyle(fontSize: 10),),);
              } else {
                final users = snapshot.data ?? [];
                if(users.isEmpty){
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height*(0.3),),
                        Icon(Icons.folder_off_outlined,size: 40,color: Colors.red,),
                        Text('Kayıtlı kullanıcı bulunmamaktadır!!',style: TextStyle(
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
                return buildUserList(users);
              }
            },
          ),
        ),
      ),
    );
  }
  ListView buildUserList(final List<User> users) {
    return ListView.builder(
      itemCount: users.length,
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
                    users[position].ad + " " + users[position].soyad,
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
                        users[position].email,
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
                        users[position].telefon,
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
                        users[position].adres,
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
                  _showConfirmDeleteDialog(context, users[position]);
                }
            ),
          ),
        );
      },
    );
  }
  void _showConfirmDeleteDialog(BuildContext context, User user) {
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
                dbHelper.deleteUser(user.id!); // Şirketi sil
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
