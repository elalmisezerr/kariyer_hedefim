import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kariyer_hedefim/Data/GoogleSignin.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/KullaniciAnasayfa.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/SirketAnasayfa.dart';
import 'package:path/path.dart';

import '../Data/DbProvider.dart';
import '../Models/Kullanici.dart';
import '../Models/Kurum.dart';
import 'SirketIslemleri/GirisSirket.dart';

class GirisEkrani extends StatelessWidget {
   GirisEkrani({Key? key}) : super(key: key);
  var dbHelper = DatabaseProvider();



  @override
  Widget build(BuildContext context) {
    var boy = MediaQuery.of(context).size.height;
    var en = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        bool exit = await
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor:Color(0xffbf1922),
              title: Text(
                "Uygulamadan çıkmak istiyor musunuz?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
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
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    GoogleSignInApi.logout();
                    SystemNavigator.pop();
                  },
                  child: const Text(
                    "EVET",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ));
        return exit;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffbf1922),
            title: Text("Ana Sayfa"),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(image: AssetImage("assect/images/Logo2.PNG")),
                    _AdminButton(),
                    SizedBox(height: 20),
                    _KullaniciButton(),
                    SizedBox(height: 20),
                    Image(
                        image: AssetImage(
                          "assect/images/Diyanetlogo.png",
                        ),
                        height: 150),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _AdminButton() {
    return Builder(builder: (context) {
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginCompany()));
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xffbf1922),
          minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          shadowColor: Colors.blueGrey,
        ),
        child: const Text(
          'Kurumsal Giriş',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      );
    });
  }

  Widget _KullaniciButton() {
    return Builder(builder: (context) {
      return ElevatedButton(
        onPressed: () {
          GoogleSignInApi.logout();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginUser()));
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xffbf1922),
          minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          shadowColor: Colors.blueGrey,
        ),
        child: const Text(
          'Kullanıcı Girişi',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      );
    });
  }
}
