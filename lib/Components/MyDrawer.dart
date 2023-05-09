// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Models/Kurum.dart';
import 'package:kariyer_hedefim/Screens/AdminIslemleri/AdmEditCompany.dart';
import 'package:kariyer_hedefim/Screens/AdminIslemleri/HomeAdmin.dart';
import 'package:kariyer_hedefim/Screens/GirisEkran%C4%B1.dart';
import 'package:kariyer_hedefim/Screens/IlanIslemleri/%C4%B0lanEkleme.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/SirketAnasayfa.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/SirketDetay.dart';

import '../Data/DbProvider.dart';
import '../Models/Kullanici.dart';
import '../Screens/AdminIslemleri/AdmEditIlan.dart';
import '../Screens/AdminIslemleri/AdmEditUsers.dart';
import '../Screens/BasvuruIslemleri/Basvurularim.dart';
import '../Screens/KullaniciIslemleri/KullaniciAnasayfa.dart';
import '../Screens/KullaniciIslemleri/KullaniciDetay.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key, required this.user}) : super(key: key);


  User user;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListTileTheme(
        textColor: const Color(0xffbf1922),
        iconColor: const Color(0xffbf1922),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 200.0,
              height: 180.0,
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 0.0,
                right: 50.0,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assect/images/Logo2.PNG', fit: BoxFit.fill),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeUser(Myuser: user)));
              },
              leading: const Icon(Icons.home),
              title: const Text('Anasayfa'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserDetail(user: user)));
              },
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('Profili Düzenle'),
            ),ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserDetail(user: user)));
              },
              leading: const Icon(Icons.favorite),
              title: const Text('Favorilerim'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Basvurularim(user: user)));
              },
              leading: const Icon(Icons.description),
              title: const Text('Başvurularım'),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
            ),
            ListTile(
              onTap: () {
                showDialog(context: context, builder: (context)=>AlertDialog(
                  backgroundColor: const Color(0xffbf1922),
                  title: const Text("Çıkış yapmak istiyor musunuz?",style:  TextStyle(
                      fontWeight: FontWeight.bold,color: Colors.white
                  ),),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("HAYIR",style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> GirisEkrani()), (route) => false),
                      child: const Text("EVET",style: TextStyle(
                        color: Colors.white,),
                      ),
                    )],
                ));

              },
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Çıkış Yap'),
            ),
            const Spacer(),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xffbf1922),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: const Text('Terms of Service | Privacy Policy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDrawerComp extends StatelessWidget {
  MyDrawerComp({Key? key, required this.company}) : super(key: key);
  Company company;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListTileTheme(
        textColor: const Color(0xffbf1922),
        iconColor: const Color(0xffbf1922),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 200.0,
              height: 180.0,
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 0.0,
                right: 50.0,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assect/images/Logo2.PNG', fit: BoxFit.fill),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeCompany(
                              company: company,
                              isLoggedin: true,
                            )));
              },
              leading: const Icon(Icons.home),
              title: const Text('Anasayfa'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompanyDetail(
                              company: company,
                            )));
              },
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('Profili Düzenle'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IlanEkle(company: company)));
              },
              leading: const Icon(Icons.description),
              title: const Text('İlan Ekle'),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
            ),
            ListTile(
              onTap: () {
                showDialog(context: context, builder: (context)=>AlertDialog(
                  backgroundColor: const Color(0xffbf1922),
                  title: const Text("Çıkış yapmak istiyor musunuz?",style: TextStyle(
                      fontWeight: FontWeight.bold,color: Colors.white
                  ),),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("HAYIR",style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> GirisEkrani()), (route) => false),
                      child: const Text("EVET",style: TextStyle(
                        color: Colors.white,),
                      ),
                    )],
                ));

              },
              leading: const Icon(Icons.logout),
              title: const Text('Çıkış Yap'),
            ),
            const Spacer(),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xffbf1922),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: const Text('Terms of Service | Privacy Policy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDrawerAdmin extends StatefulWidget {
  const MyDrawerAdmin({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDrawerAdmin> createState() => _MyDrawerAdminState();
}

class _MyDrawerAdminState extends State<MyDrawerAdmin> {
  var dbHelper = DatabaseProvider();


   Company? company;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListTileTheme(
        textColor: const Color(0xffbf1922),
        iconColor: const Color(0xffbf1922),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 200.0,
              height: 180.0,
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 0.0,
                right: 50.0,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assect/images/Logo2.PNG', fit: BoxFit.fill),
            ),
            Expanded(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeAdmin(Mycompany: company,)));
                },
                leading: const Icon(Icons.home),
                title: const Text('Anasayfa',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdmEditCompany()));
                },
                leading: const Icon(Icons.description),
                title: const Text('Şirket İşlemleri',style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdmEditIlan()));
                },
                leading: const Icon(Icons.description),
                title: const Text('İlan İşlemleri',style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdmEditUsers()));
                },
                leading: const Icon(Icons.description),
                title: const Text('Kullanıcı İşlemleri',style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 10,),
            Expanded(
              child: ListTile(
                onTap: () {
                  showDialog(context: context, builder: (context)=>AlertDialog(
                    backgroundColor: const Color(0xffbf1922),
                    title: const Text("Çıkış yapmak istiyor musunuz?",style: TextStyle(
                        fontWeight: FontWeight.bold,color: Colors.white
                    ),),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("HAYIR",style: TextStyle(
                          color: Colors.white,
                        ),),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> GirisEkrani()));
                        },  child: const Text("EVET",style: TextStyle(
                          color: Colors.white,),
                        ),
                      )],
                  ));

                },
                leading: const Icon(Icons.logout),
                title: const Text('Çıkış Yap',style: TextStyle(fontSize: 18),),
              ),
            ),
            const Spacer(),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xffbf1922),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: const Text('Terms of Service | Privacy Policy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
