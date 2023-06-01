import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Screens/AdminIslemleri/HomeAdmin.dart';
import 'package:kariyer_hedefim/Screens/GirisEkranı.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/LoginGoogleUsers.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/ResetPasswordKullanici/Deneme.dart';
import 'package:kariyer_hedefim/components/Button.dart';
import 'package:kariyer_hedefim/components/Square.dart';
import 'package:kariyer_hedefim/components/TextFormField.dart';
import 'package:kariyer_hedefim/validation/ValidationLogin.dart';
import '../../Data/GoogleSignin.dart';
import '../../Models/Kullanici.dart';
import '../../Models/Log.dart';
import 'KullaniciAnasayfa.dart';
import 'KullaniciEkle.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({Key? key}) : super(key: key);

  @override
  State<LoginUser> createState() => _LoginUser();
}

class _LoginUser extends State<LoginUser> with Loginvalidationmixin {
  User? user;
  var dbHelper = DatabaseProvider();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  LogModel? log;

  @override
  void initState() {
    GoogleSignInApi.logout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor:Color(0xffbf1922),
              title: Text(
                "Önceki sayfaya dönmek istiyor musunuz?",
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
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => GirisEkrani()),
                            (route) => false);
                    GoogleSignInApi.logout();
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
          backgroundColor: Colors.grey[300],
          body: Container(
            child: SafeArea(
              child: Center(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: govde(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  List<Widget> govde() {
    return [
      // logo
      const Icon(
        Icons.person,
        color: Color(0xffbf1922),
        size: 100,
      ),
      // welcome back, you've been missed
      Center(
        child: Container(
          child: Text(
            "Kariyer Hedefim Uygulamasına Hoşgeldiniz!",
            style: TextStyle(
              color: Color(0xffbf1922),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      // username textfield
      SizedBox(height: 20),
      MyTextField(
        validator: validateUserName,
        controller: userNameController,
        hintText: "Kullanıcı Adı",
        obscureText: false,
      ),
      // password textfield
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          validator: validatePassword,
          controller: passwordController,
          obscureText: _isObscured,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffbf1922)),
              borderRadius: BorderRadius.circular(20),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: "Şifre",
            hintStyle: TextStyle(color: Colors.grey[500]),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            ),
          ),
        ),
      ),

      // forgot password?
      InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ResetPasswordPageUser()));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Parolanızı mı unuttunuz?",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      // sign in button
      MyButton(onTap: () async {
        String hashPassword(String password) {
          var bytes = utf8.encode(password);
          var digest = sha256.convert(bytes);
          return digest.toString();
        }

        await girisYap(
            userNameController.text, hashPassword(passwordController.text));
      }),
      const SizedBox(
        height: 20,
      ),
      // google+ apple sign in buttons
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              signIn();
            },
            child: const SquareTile(imagePath: 'assect/images/google.png'),
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      // not a member? register now
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UsersAdd()));
                },
                child: Row(
                  children: [
                    Text(
                      "Üye değil misin?",
                      style: TextStyle(
                        color: Color(0xffbf1922),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Kayıt ol",
                      style: TextStyle(
                          color: Color(0xffbf1922),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GirisEkrani()));
            },
            child: Text(
              "Anasayfa'ya Git",
              style: TextStyle(
                  color: Color(0xffbf1922), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ];
  }
  Future<String?> isLogedin() async {
    var temp = await dbHelper.getUserLoggedInStatus(userNameController.text);
    print(await dbHelper.getUserLoggedInStatus(userNameController.text));
    if (temp == null) {
      return "";
    } else {
      bool isLoggedIn = "${temp}".toLowerCase() == 'true'; // String değeri bool tipine dönüştürülüyor
      print(temp);
      if (temp) {
        return "Çevrimiçi";
      } else if (!temp) {
        return "Çevirim Dışı";
      } else {
        // "0" veya "1" dışında bir değer varsa buraya girer
        return "Bilinmeyen Durum";
      }
    }
  }



  Future<LogModel?> logg(String islem) async {
    String? cevirimDurumu = await isLogedin();
    LogModel? log;
    if (cevirimDurumu != null) {
      log = LogModel.withoutId(
        kisi: "Kullanıcı: " + user!.email,
        kull_id: user!.id.toString(),
        cevirimici: cevirimDurumu,
        islem: islem,
        tarih: DateTime.now().toString(),
      );
    } else {
      throw Exception("Failed to get cevirimDurumu");
    }
    return log;
  }



  Future<void> girisYap(String x, String y) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var result = await dbHelper.checkUser(x, y);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xffbf1922),
          content: Text("Giriş Başarılı!"),
        ));
        user = await dbHelper.getUserByEmail(userNameController.text);
        await dbHelper.updateUserLoggedInStatus(result.email, true);
        var logResult = await logg("Giriş Yapıldı");
        await dbHelper.insertLog(logResult!); // Ensure logResult is not null before inserting
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeUser(Myuser: result),
          ),
        );
      } else {
        print("Hatalı Giriş");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xffbf1922),
            content: Text(
              'Giriş Bilgileri Hatalı!!!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future signIn2() async {
    final user = await GoogleSignInApi.login();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş Hatalı!")),
      );
    } else {
      if (user.email.toString() == "szrelalmis@gmail.com") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeAdmin(Mycompany: user)));
      } else {
        if (user.email.isNotEmpty) {
          bool kullaniciVarMi =
              await dbHelper.kullaniciAdiKontrolEt(user.email.toString()) ||
                  await dbHelper.sirketAdiKontrolEt(user.email.toString());

          if (kullaniciVarMi == false) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => LoginGoogleUsers(userr: user)),
            );

            String email = 'szrelalmis@gmail.com';
            await dbHelper.checkIsAdmin(email);
            print("Kullanici yok");
          } else {
            User? temp = await dbHelper.getUserByEmail(user.email.toString());

            if (temp != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeUser(Myuser: temp)),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Color(0xffbf1922),
                  content: Text(
                      'Bu kullanıcı, şirket olarak kaydedilmiş.Lütfen şirket girişi yapın!!!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                  duration: Duration(
                    seconds: 2,
                  ),
                ),
              );
              GoogleSignInApi.logout();
            }
          }
        }
      }
    }
  }

  Future signIn() async {
    final user = await GoogleSignInApi.login();
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Giriş Başarısız!")));
    } else {
      if (user.email.toString() == "szrelalmis@gmail.com") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Giriş Başarılı!")));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeAdmin(
                      Mycompany: user,
                    )));
      } else {
        if (user.email.isNotEmpty) {
          bool kullaniciVarMi =
              await dbHelper.kullaniciAdiKontrolEt(user.email.toString()) ||
                  await dbHelper.sirketAdiKontrolEt(user.email.toString());
          if (kullaniciVarMi == false) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(backgroundColor: Color(0xffbf1922),content: Text("Giriş Başarılı!")));
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginGoogleUsers(userr: user)));
            String email = 'szrelalmis@gmail.com';
            await dbHelper.checkIsAdmin(email);
          } else {
            var temp = await dbHelper.getUserByEmail(user.email.toString());
            if (temp != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Color(0xffbf1922),
                  content: Text(
                "Giriş Başarılı!",
              )));
              await dbHelper.updateUserLoggedInStatus(temp.email, true);

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeUser(
                          Myuser: temp,
                        )),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Color(0xffbf1922),
                  content: Text(
                      'Bu email, şirket olarak kaydedilmiş.Lütfen kullanıcı girişi yapın!!!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                  duration: Duration(
                    seconds: 2,
                  ),
                ),
              );
            }
          }
        }
      }
    }
  }
}
