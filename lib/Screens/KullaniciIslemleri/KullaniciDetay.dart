import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/KullaniciAnasayfa.dart';
import 'package:kariyer_hedefim/Validation/ValidationUser.dart';

import '../../Data/DbProvider.dart';
import '../../Models/User.dart';

class UserDetail extends StatefulWidget {
  User user;
  UserDetail({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState(user);
}

enum Options { delete, update }

class _UserDetailState extends State<UserDetail> {
  User? user;
  var dbHelper = DatabaseProvider();
  var txtName = TextEditingController();
  var txtSurname = TextEditingController();
  var txtBirthDate = TextEditingController();
  var txtuserName = TextEditingController();
  var txtpassWord = TextEditingController();
  var txtTelefon = TextEditingController();
  var txtAdres = TextEditingController();
  final formKey = GlobalKey<FormState>();
  _UserDetailState(this.user);
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  void initState() {
    txtName.text = user?.ad ?? '';
    txtSurname.text = user?.soyad ?? '';
    txtBirthDate.text =ParseDate(user!.dogumtarihi.toString())??'';
      //  DateFormat('dd-MM-yyyy').format(user?.dogumtarihi ?? DateTime.now());
    txtuserName.text = user?.email ?? '';
    txtpassWord.text = user?.password ?? '';
    txtTelefon.text = user?.telefon ?? '';
    txtAdres.text = user?.adres ?? '';
    print(user!.dogumtarihi.toString());
    super.initState();
  }

  bool _isObscured = true; // şifrenin gizli olup olmadığını takip eder

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.white,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      drawer: MyDrawer(user: widget.user),
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
        title: Text(
          "Hoşgeldin ${user!.ad} ",
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          PopupMenuButton<Options>(
            onSelected: selectProcess,
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<Options>>[
              PopupMenuItem<Options>(
                value: Options.delete,
                child: Text("Sil"),
              ),
              PopupMenuItem<Options>(
                value: Options.update,
                child: Text("Güncelle"),
              ),
            ],
          )
        ],
      ),

          body: Form(
          child: buildGovde(),
        ),
      ),
    );
  }
  ParseDate(String date){
    DateTime birthDate = DateTime.parse(date);
    String formattedDate = '${birthDate.day}-${birthDate.month}-${birthDate.year}';
    return formattedDate;
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
          buildSurname(),
          SizedBox(
            height: 5.0,
          ),
          buildBirthDate(),
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
          Row(
            children: [
              Flexible(
                flex: 1,
                child: buildUpdateButton(),
              ),
              SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: buildDeleteButton(),
              ),
            ],
          ),
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

  buildSurname() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: TextField(
        controller: txtSurname,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Soyadınızı Giriniz",
            labelText: "Soyad",
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.yellow,
      ),
    );
  }



  Widget buildBirthDate() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: TextField(
        onTap: _showDatePicker,
        controller: txtBirthDate,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.cake),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Doğum Tarihini Giriniz",
            labelText: "Doğum Tarihi",
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
  }buildAdres() {
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



  Future<void> _showDatePicker() async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2025),
        locale: const Locale('tr', 'TR') // Türkçe dil desteği ekledik
    );
    if (selectedDate != null) {
      setState(() {
        // Use DateFormat to format the selected date
        txtBirthDate.text = DateFormat('dd-MM-yyyy', 'tr_TR').format(selectedDate);
      });
    }
  }


  void selectProcess(Options options) async {
    switch (options) {
      case Options.delete:
        await dbHelper.deleteUser(user!.id!);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginUser()));
        break;
      case Options.update:
        {
          user!.ad = txtName.text;
          user!.soyad = txtSurname.text;
          user!.dogumtarihi = DateFormat('dd-MM-yyyy').parse(txtBirthDate.text);
          user!.email = txtuserName.text;
          user!.password = txtpassWord.text;
          user!.telefon = txtTelefon.text;
          user!.adres = txtAdres.text;
          await dbHelper.updateUser(user!);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeUser(user: widget.user)));
        }
        break;
      default:
    }
  }

  buildUpdateButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate() && user!=null) {
          formKey.currentState!.save();
          user!.ad = txtName.text;
          user!.soyad = txtSurname.text;
          user!.dogumtarihi = DateFormat('dd-MM-yyyy').parse(txtBirthDate.text);
          user!.email = txtuserName.text;
          user!.password = txtpassWord.text;
          user!.telefon = txtTelefon.text;
          user!.adres = txtAdres.text;
          await dbHelper.updateUser(user!);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeUser(user: widget.user)));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2),
          ],
          color: Colors.green,
        ),
        child: Text(
          "Güncelle",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  buildDeleteButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          await dbHelper.deleteUser(user!.id!);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginUser()));
        }
      },
      child: Container(
        // width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2),
          ],
          color: Colors.grey.shade700,
        ),
        child: Text(
          "Ekle",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
