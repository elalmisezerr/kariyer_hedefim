import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Screens/GirisEkranı.dart';
import 'package:kariyer_hedefim/components/Button.dart';
import 'package:kariyer_hedefim/components/Square.dart';
import 'package:kariyer_hedefim/components/TextFormField.dart';
import 'package:kariyer_hedefim/validation/ValidationLogin.dart';
import '../../Data/GoogleSignin.dart';
import '../LoggedInPage.dart';
import 'AdminAnasayfa.dart';
import 'AdminEkle.dart';
import 'LoginwithGoole.dart';

class LoginCompany extends StatefulWidget {
  const LoginCompany({Key? key}) : super(key: key);

  @override
  State<LoginCompany> createState() => _LoginCompany();
}

class _LoginCompany extends State<LoginCompany> with Loginvalidationmixin {
  var dbHelper = DatabaseProvider();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
    );
  }

  List<Widget> govde() {
    return [
      // logo
      const Icon(
        Icons.admin_panel_settings,
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
              borderSide: BorderSide(color: Colors.grey.shade400),
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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Parolanızı mı unuttunuz?",
              style: TextStyle(color: Color(0xffbf1922)),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      // sign in button
      MyButton(onTap: () async {
        await girisYap(userNameController.text, passwordController.text);
      }),
      const SizedBox(
        height: 5,
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
                          builder: (context) => const CompanyAdd()));
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
                  MaterialPageRoute(builder: (context) => const GirisEkrani()));
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

  Future<void> girisYap(String x, String y) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var result = await dbHelper.checkCompany(x, y);
      saveStudent();
      if (result != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeAdmin(
                      company: result,
                      isLoggedin: true,
                    )));
      } else {
        print("Hatalı Giriş");
      }
    }
  }

  Future signIn() async {
    final user = await GoogleSignInApi.login();
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sign In Failed!")));
    } else {
      if (user.email.isNotEmpty) {
        bool kullaniciVarMi =
            await dbHelper.kullaniciAdiKontrolEt(user.email.toString()) ||
                await dbHelper.sirketAdiKontrolEt(user.email.toString());
        if (kullaniciVarMi == false) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => LoginGooleCompany(user: user)));
          String email = 'szrelalmis@gmail.com';
          await dbHelper.checkIsAdmin(email);
        } else {
          var temp = await dbHelper.getCompanyByEmail(user.email.toString());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeAdmin(company: temp, isLoggedin: true)));
        }
      }
    }
  }

  void saveStudent() {
    print("çalıştı");
  }
}
