import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Screens/AdminIslemleri/GirisAdmin.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';
import 'package:path/path.dart';

class GirisEkrani extends StatelessWidget {
  const GirisEkrani({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boy = MediaQuery.of(context).size.height;
    var en = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        title: Text("Ana Sayfa"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: boy,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assect/images/asd.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 370,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        _AdminButton(),
                        SizedBox(height: 5),
                        _KullaniciButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _AdminButton() {
    return Builder(builder: (context) {
      return TextButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginCompany()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 60),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 1)
            ],
          ),
          child: const Text(
            'Şirket Girişi',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );
    });
  }

  Widget _KullaniciButton() {
    return Builder(builder: (context) {
      return TextButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginUser()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 60),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 1)
            ],
          ),
          child: const Text(
            'Kullanıcı Girişi',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );
    });
  }
}
/* ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginUser()),
                          );
                        },
                        child: Text(
                          "--Kullanıcı Girişi--",
                          style: TextStyle(
                              color: Colors.white, fontSize: 25),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginCompany()),
                          );
                        },
                        child: Text(
                          "--Admin Girişi--",
                          style: TextStyle(
                              color: Colors.white, fontSize: 25),
                        ),
                      ),*/
/*children: [
              Container(
                height: boy,
                //width:en*.10 ,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assect/images/asd.jpg"),
                        fit: BoxFit.cover)),
                /*child:
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.blueGrey,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.white, Colors.white],
                            ),
                          ),
                          child: const Text(
                            '--Kullanıcı Girişi--',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.blueGrey,
                                  offset: Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.white, Colors.white],
                              ),
                            ),
                            child: const Text(
                              '--Admin Girişi-- ',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ))
                    ],
                  ),
                ),*/
              ),
              _LoginButton(),
            ],*/
