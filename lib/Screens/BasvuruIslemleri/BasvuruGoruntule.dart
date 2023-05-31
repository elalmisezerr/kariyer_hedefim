import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/Basvuru.dart';
import 'package:kariyer_hedefim/Screens/BasvuruIslemleri/Detay/BasvuranDetay.dart';

import '../../Models/Ilan.dart';
import '../../Models/Kullanici.dart';

class BasvuruGoruntule extends StatefulWidget {
  Ilanlar? ilanlar;

  BasvuruGoruntule({Key? key, required this.ilanlar}) : super(key: key);

  @override
  State<BasvuruGoruntule> createState() => _BasvuruGoruntuleState();
}

class _BasvuruGoruntuleState extends State<BasvuruGoruntule> {
  var dbHelper = DatabaseProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffbf1922),
        title: Text("Başvuranlar"),
      ),
      body: Container(

        child: FutureBuilder<List<User>>(
          future: dbHelper
              .getKullanicilarByIlanlarId(widget.ilanlar!.id.toString()),
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
              final users = snapshot.data ?? [];
              return buildUserList(users);
            }
          },
        ),
      ),
    );
  }

  ListView buildUserList(final List<User> users) {
    if (users.isEmpty) {
      return ListView(
        children: [
          ListTile(
            title:Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*(0.3),),
                  Icon(Icons.folder_off_outlined,size: 40,color: Colors.red,),
                  Text('Bu ilana başvuran kimse bulunamadı!!',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.red,
                  ),),
                ],
              ),
            ),
          ),
        ],
      );
    }

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
              trailing: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BasvuranDetay()));
                  },
                  child: Icon(Icons.file_open_outlined,size: 45,
                  color: Color(0xffbf1922),)),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }
}
