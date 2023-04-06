import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Screens/GirisEkranı.dart';
import 'package:kariyer_hedefim/components/Button.dart';
import 'package:kariyer_hedefim/components/Square.dart';
import 'package:kariyer_hedefim/components/TextFormField.dart';
import 'package:kariyer_hedefim/validation/ValidationLogin.dart';
import '../../Data/GoogleSignin.dart';
import '../LoggedInPage.dart';
import 'KullaniciAnasayfa.dart';
import 'KullaniciEkle.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({Key? key}) : super(key: key);

  @override
  State<LoginUser> createState() => _LoginUser();
}

class _LoginUser extends State<LoginUser> with Loginvalidationmixin {

  var dbHelper = DatabaseProvider();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Container(
            child: Center(
              child: Form(
                key: formKey,
                child: ListView(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: govde(),
                ),
              ),
            ),
          ),
        ));
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
          child: Center(
            child: Expanded(
              child: Text(
                "Kariyer Hedefim Uygulamasına Hoşgeldiniz!",
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      // username textfield
      MyTextField(
        validator: validateUserName,
        controller: userNameController,
        hintText: "Username",
        obscureText: false,
      ),
      // password textfield
      MyTextField(
        validator: validatePassword,
        controller: passwordController,
        hintText: "Password",
        obscureText: true,
      ),
      // forgot password?
      Padding(
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
      const SizedBox(
        height: 10,
      ),
      // sign in button
      MyButton(
          onTap:() async {
    await girisYap(userNameController.text, passwordController.text);}),
      const SizedBox(
        height: 4,
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
      // not a member? register now
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersAdd()));
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Üye değil misin?",style: TextStyle(
                      color: Color(0xffbf1922),
                    ),),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Kayıt ol",
                      style: TextStyle(
                          color: Color(0xffbf1922), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const GirisEkrani()));
                      },
                      child: Text(
                        "Anasayfa'ya Git",
                        style: TextStyle(
                            color: Color(0xffbf1922), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),

    ];
  }

  Future<void> girisYap(String x,String y) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var result = await dbHelper.checkUser(x,y);
      saveStudent();
      if (result != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeUser(user: result,)));
      } else {
        print("Hatalı Giriş");
      }
    }
  }

  Future signIn() async{
    final user=await GoogleSignInApi.login();
    if(user==null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign In Failed!")));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoggedInPage(user:user)));
    }



  }
  void saveStudent() {
    print("çalıştı");
  }
}
