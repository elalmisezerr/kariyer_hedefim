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

class _UserDetailState extends State<UserDetail>  {
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
    txtName.text = user!.ad;
    txtSurname.text = user!.soyad;
    txtBirthDate.text = DateFormat('yyyy-MM-dd').format(user!.dogumtarihi);
    txtuserName.text = user!.email;
    txtpassWord.text = user!.password;
    txtTelefon.text = user!.telefon;
    txtAdres.text = user!.adres;
    super.initState();

  }

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
      drawer: MyDrawer(user:widget.user),
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
          title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(child: Text("${user!.ad}'in Profil Sayfasına Hoşgeldiniz")),
              ),
          actions: <Widget>[
            PopupMenuButton<Options>(
                onSelected: selectProcess,
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
                      PopupMenuItem<Options>(
                        value: Options.delete,
                        child: Text("Sil"),
                      ),
                      PopupMenuItem<Options>(
                        value: Options.update,
                        child: Text("Güncelle"),
                      ),
                    ])
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
          buildUsername(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Adınızı giriniz",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          controller: txtName,
        )
      ],
    );
  }

  buildSurname() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Soyadınızı giriniz",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          controller: txtSurname,
        )
      ],
    );
  }

  buildBirthDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Doğum tarihinizi seçin",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          //readOnly: true,
          onTap: _showDatePicker,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.cake),
          ),
          controller: txtBirthDate,
        )
      ],
    );
  }

  buildUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kullanıcı adı giriniz",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          controller: txtuserName,
          keyboardType: TextInputType.emailAddress,
        )
      ],
    );
  }

  buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Şifrenizi girin",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
          controller: txtpassWord,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        )
      ],
    );
  }
  buildTelefon() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Telefon numaranızı giriniz",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          controller: txtTelefon,
          keyboardType: TextInputType.phone,
        )
      ],
    );
  }

  buildAdres() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Adresinizi giriniz",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.home),
          ),
          controller: txtAdres,
          maxLines: 3,
        )
      ],
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2025));
    if (selectedDate != null) {
      setState(() {
        txtBirthDate.text =
            (DateFormat('yyyy-MM-dd').format(selectedDate)).toString();
      });
    }
  }

  void selectProcess(Options options) async {
    switch (options) {
      case Options.delete:
        await dbHelper.deleteUser(user!.id!);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginUser()));
        break;
      case Options.update: {
          user!.ad = txtName.text;
          user!.soyad = txtSurname.text;
          user!.dogumtarihi = DateFormat('yyyy-MM-dd').parse(txtBirthDate.text);
          user!.email = txtuserName.text;
          user!.password = txtpassWord.text;
          user!.telefon = txtTelefon.text;
          user!.adres = txtAdres.text;
          await dbHelper.updateUser(user!);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeUser(user: widget.user)));
        }
        break;
      default:
    }
  }

  buildUpdateButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          print(user!.ad);
          await dbHelper.updateUser(User(
            id: user!.id,
            ad: txtName.text,
            soyad: txtSurname.text,
            dogumtarihi: DateFormat('yyyy-MM-dd').parse(txtBirthDate.text),
            email: txtuserName.text,
            password: txtpassWord.text,
            telefon: txtTelefon.text,
            adres: txtAdres.text,
          ));
        }
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeUser(user: widget.user)));
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
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginUser()));

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
