import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Screens/AdminIslemleri/AdminAnasayfa.dart';
import 'package:kariyer_hedefim/Screens/AdminIslemleri/AdminEkle.dart';
import 'package:kariyer_hedefim/Screens/GirisEkranı.dart';
import 'package:kariyer_hedefim/components/Button.dart';
import 'package:kariyer_hedefim/components/Square.dart';
import 'package:kariyer_hedefim/components/TextFormField.dart';
import 'package:kariyer_hedefim/validation/ValidationLogin.dart';
import '../../Data/GoogleSignin.dart';
import '../LoggedInPage.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: Form(
              key: formKey,
              child: ListView(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: govde(),
              ),
            ),
          ),
        ));
  }

  List<Widget> govde() {
    return [
      const SizedBox(
        height: 25,
      ),
      // logo
      const Icon(
        Icons.admin_panel_settings,
        color: Colors.blueGrey,
        size: 100,
      ),
      const SizedBox(
        height: 25,
      ),
      // welcome back, you've been missed
      Center(
        child: Text(
          "Kariyer Hedefim Uygulamasına Hoşgeldiniz!",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
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
        height: 25,
      ),
      // sign in button
      MyButton(
          onTap:() async {
    await girisYap(userNameController.text, passwordController.text);}),

      const SizedBox(
        height: 25,
      ),
      //or continue with
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          children: [
            Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[500],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Or continue with",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ))
          ],
        ),
      ),
      const SizedBox(
        height: 25,
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
        height: 25,
      ),

      // not a member? register now
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CompanyAdd()));
            },
            child: Row(
              children: [
                Text("Üye değil misin?",style: TextStyle(
                  color: Colors.grey.shade700,
                ),),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "Kayıt ol",
                  style: TextStyle(
                      color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
                      color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                ),
            ),
        ],
      )
    ];
  }

  Future<void> girisYap(String x,String y) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var result = await dbHelper.checkCompany(x,y);
      saveStudent();
      if (result != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeAdmin(company: result,isLoggedin: true,)));
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
