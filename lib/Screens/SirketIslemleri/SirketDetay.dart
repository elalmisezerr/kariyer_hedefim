import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Models/Company.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/SirketAnasayfa.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/GirisSirket.dart';
import 'package:kariyer_hedefim/Validation/ValidationCompanyAddMixin.dart';

import '../../Data/DbProvider.dart';
import '../GirisEkranı.dart';

class AdminDetail extends StatefulWidget {
  Company company;
  AdminDetail({Key? key, required this.company}) : super(key: key);

  @override
  State<AdminDetail> createState() => _AdminDetailState();
}

class _AdminDetailState extends State<AdminDetail>
    with ValidationCompanyAddMixin {
  var dbHelper = DatabaseProvider();
  var formKey = GlobalKey<FormState>();
  var txtName = TextEditingController();
  var txtuserName = TextEditingController();
  var txtpassWord = TextEditingController();
  var txtTelefon = TextEditingController();
  var txtAdres = TextEditingController();
  final _advancedDrawerController = AdvancedDrawerController();
  bool _isObscured = true;

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void logout() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GirisEkrani()));
    });
  }

  @override
  void initState() {
    txtName.text = widget.company.isim;
    txtuserName.text = widget.company.email;
    txtpassWord.text = widget.company.sifre;
    txtTelefon.text = widget.company.telefon;
    txtAdres.text = widget.company.adres;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.white,
      controller: _advancedDrawerController,
      animationCurve: Curves.elasticInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,

      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      drawer: MyDrawerComp(
        company: widget.company,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffbf1922),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
          centerTitle: true,
          title: Text("Şirket Profilini Düzenle"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(onPressed: logout, icon: Icon(Icons.logout))
          ],
        ),
        body: Form(
          child: buildGovde(),
        ),
      ),
    );
  }

  buildGovde() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          // buildExample(),
          buildName(),
          SizedBox(
            height: 5.0,
          ),
          buildEmail(),
          SizedBox(
            height: 5.0,
          ),
          buildPassword(),
          SizedBox(
            height: 5.0,
          ),
          buildTelefon(),
          SizedBox(
            height: 5.0,
          ),
          buildAdres(),
          SizedBox(
            height: 5.0,
          ),
          buildSaveButton(),
          SizedBox(
            height: 5.0,
          ),
          buildDeleteButton()
        ],
      ),
    );
  }

  buildName() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: TextField(
        controller: txtName,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Adınızı Giriniz",
            labelText: "Ad",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }

  buildEmail() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: TextField(
        controller: txtuserName,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Email Giriniz",
            labelText: "Email",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }

  buildPassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: TextField(
        controller: txtpassWord,
        obscureText: _isObscured,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          hintText: "Şifre Giriniz",
          labelText: "Şifre",
          filled: true,
          fillColor: Colors.white,
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
        cursorColor: Colors.yellow,
      ),
    );
  }

  buildTelefon() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: TextField(
        controller: txtTelefon,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Telefon Numarınızı Giriniz",
            labelText: "Telefon",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }

  buildAdres() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: TextField(
        maxLines: 3,
        maxLength: 30,
        controller: txtAdres,
        keyboardType: TextInputType.streetAddress,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.home),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Adresinizi Giriniz",
            labelText: "Adres",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }

  buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: ElevatedButton(
        onPressed: () async {
          if (widget.company!=null) {
            widget.company.isim=txtName.text;
            widget.company.email=txtuserName.text;
            widget.company.sifre=txtpassWord.text;
            widget.company.telefon=txtTelefon.text;
            widget.company.adres=txtAdres.text;
            await dbHelper.updateCompany(widget.company).then((value) {
              if (value != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeCompany(company: widget.company, isLoggedin: true)));
              }
            });
          }
        },
        child: Text(
          "Kaydet",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: Color(0xffbf1922)),
      ),
    );
  }

  buildDeleteButton() {
    return ElevatedButton(
        onPressed: () async {
          if (widget.company!=null) {
            await dbHelper.deleteCompany(widget.company.id!);

            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => LoginCompany()),
                (Route<dynamic> route) => false,);
          }
        },
        child: Text("Sil"));
  }
}