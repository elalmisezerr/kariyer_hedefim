import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kariyer_hedefim/Data/GoogleSignin.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';
import 'package:path/path.dart';

import 'SirketIslemleri/GirisSirket.dart';

class GirisEkrani extends StatelessWidget {
  const GirisEkrani({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boy = MediaQuery.of(context).size.height;
    var en = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
              ),
              backgroundColor: Color(0xffbf1922),
              title: Text(
                "Uygulamadan çıkmak istiyor musunuz?",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "HAYIR",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xffbf1922)),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    GoogleSignInApi.logout();
                    SystemNavigator.pop();
                  },
                  child: Text(
                    "EVET",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xffbf1922)),
                  ),
                ),
              ],
            );
          },
        );
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
          GoogleSignInApi.logout();
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
          'Şirket Girişi',
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
