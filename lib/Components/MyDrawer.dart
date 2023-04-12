import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Models/Company.dart';
import 'package:kariyer_hedefim/Screens/GirisEkran%C4%B1.dart';
import 'package:kariyer_hedefim/Screens/IlanIslemleri/%C4%B0lanEkleme.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/AdminAnasayfa.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/AdminDetay.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/GirisAdmin.dart';

import '../Models/User.dart';
import '../Screens/BasvuruIslemleri/Basvurularim.dart';
import '../Screens/KullaniciIslemleri/KullaniciAnasayfa.dart';
import '../Screens/KullaniciIslemleri/KullaniciDetay.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key, required this.user}) : super(key: key);
  User user;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: ListTileTheme(
          textColor: Color(0xffbf1922),
          iconColor: Color(0xffbf1922),
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
                decoration: BoxDecoration(
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
                          builder: (context) => HomeUser(user: user)));
                },
                leading: Icon(Icons.home),
                title: Text('Anasayfa'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserDetail(user: this.user)));
                },
                leading: Icon(Icons.account_circle_rounded),
                title: Text('Profili Düzenle'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Basvurularim(user: user)));
                },
                leading: Icon(Icons.description),
                title: Text('Başvurularım'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.settings),
                title: Text('Ayarlar'),
              ),ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>GirisEkrani()));
                },
                leading: Icon(Icons.logout_outlined),
                title: Text('Çıkış Yap'),
              ),
              Spacer(),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xffbf1922),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
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
      child: Container(
        child: ListTileTheme(
          textColor: Color(0xffbf1922),
          iconColor: Color(0xffbf1922),
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
                decoration: BoxDecoration(
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
                          builder: (context) => HomeAdmin(company: company, isLoggedin: true,)));
                },
                leading: Icon(Icons.home),
                title: Text('Anasayfa'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>AdminDetail(company: company,)));
                },
                leading: Icon(Icons.account_circle_rounded),
                title: Text('Profili Düzenle'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>IlanEkle(company: company)));
                },
                leading: Icon(Icons.description),
                title: Text('İlan Ekle'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.settings),
                title: Text('Ayarlar'),
              ),ListTile(
                onTap: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginCompany()), (route) => false);
                },
                leading: Icon(Icons.logout),
                title: Text('Çıkış Yap'),
              ),
              Spacer(),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xffbf1922),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
