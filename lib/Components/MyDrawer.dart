import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Data/GoogleSignin.dart';
import 'package:kariyer_hedefim/Models/Company.dart';
import 'package:kariyer_hedefim/Screens/AdminIslemleri/AdmEditCompany.dart';
import 'package:kariyer_hedefim/Screens/AdminIslemleri/EditAdmin.dart';
import 'package:kariyer_hedefim/Screens/AdminIslemleri/HomeAdmin.dart';
import 'package:kariyer_hedefim/Screens/GirisEkran%C4%B1.dart';
import 'package:kariyer_hedefim/Screens/IlanIslemleri/%C4%B0lanEkleme.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/SirketAnasayfa.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/SirketDetay.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/GirisSirket.dart';

import '../Data/DbProvider.dart';
import '../Models/User.dart';
import '../Screens/AdminIslemleri/AdmEditBasvuru.dart';
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
      child: Container(
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
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GirisEkrani()));
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
                          builder: (context) => HomeCompany(
                                company: company,
                                isLoggedin: true,
                              )));
                },
                leading: Icon(Icons.home),
                title: Text('Anasayfa'),
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
                leading: Icon(Icons.account_circle_rounded),
                title: Text('Profili Düzenle'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IlanEkle(company: company)));
                },
                leading: Icon(Icons.description),
                title: Text('İlan Ekle'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.settings),
                title: Text('Ayarlar'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginCompany()),
                      (route) => false);
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

class MyDrawerAdmin extends StatefulWidget {
  MyDrawerAdmin({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDrawerAdmin> createState() => _MyDrawerAdminState();
}

class _MyDrawerAdminState extends State<MyDrawerAdmin> {
  var dbHelper = DatabaseProvider();

  Future<void> loadCompany() async {
    Company? company = await dbHelper.getCompanyByEmail("szrelalmis@gmail.com");
    setState(() {
      this.company = company;
    });
  }


  late Company? company;

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
              Expanded(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeAdmin(Mycompany: company,)));
                  },
                  leading: Icon(Icons.home),
                  title: Text('Anasayfa',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditAdmin(company: company)));
                  },
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text('Profili Düzenle',style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdmEditCompany()));
                  },
                  leading: Icon(Icons.description),
                  title: Text('Şirket İşlemleri',style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdmEditIlan()));
                  },
                  leading: Icon(Icons.description),
                  title: Text('İlan İşlemleri',style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdmEditUsers()));
                  },
                  leading: Icon(Icons.description),
                  title: Text('Kullanıcı İşlemleri',style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdmEditBasvuru()));
                  },
                  leading: Icon(Icons.description),
                  title: Text('Başvuru İşlemleri',style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: ListTile(
                  onTap: () {},
                  leading: Icon(Icons.settings),
                  title: Text('Ayarlar',style: TextStyle(fontSize: 18)),
                ),
              ),

              SizedBox(height: 10,),
              Expanded(
                child: ListTile(
                  onTap: () async {
                    await GoogleSignInApi.logout();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginCompany()),
                        (route) => false);
                  },
                  leading: Icon(Icons.logout),
                  title: Text('Çıkış Yap',style: TextStyle(fontSize: 18),),
                ),
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
