import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/GirisKullanici.dart';
import 'package:kariyer_hedefim/Screens/KullaniciIslemleri/KullaniciAnasayfa.dart';
import 'package:kariyer_hedefim/Validation/ValidationUser.dart';

import '../../Data/DbProvider.dart';
import '../../Data/GoogleSignin.dart';
import '../../Models/Kullanici.dart';
import '../GirisEkranı.dart';

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
    txtBirthDate.text = user!.dogumtarihi;
    //  DateFormat('dd-MM-yyyy').format(user?.dogumtarihi ?? DateTime.now());
    txtuserName.text = user?.email ?? '';
    txtpassWord.text = user?.password ?? '';
    txtTelefon.text = user?.telefon ?? '';
    txtAdres.text = user?.adres ?? '';
    super.initState();
  }

  String dateFormatter(DateTime date) {
    String formattedDate;
    return formattedDate =
        "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString()}";
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
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: Color(0xffbf1922),
                            title: Text(
                              "Güvenli Çıkış Yapın",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                    "Çıkış yapmak istiyor musunuz?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text(
                                  "HAYIR",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => logout(),
                                child: const Text(
                                  "EVET",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ));
                },
                icon: Icon(Icons.logout))
          ],
          title: Text(
            "Hoşgeldin ${user!.ad} ",
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: Form(
          child: buildGovde(),
        ),
      ),
    );
  }

  void logout() {
    setState(() async {
      if (GoogleSignInApi != null) {
        await GoogleSignInApi.logout();
      }
      await dbHelper.updateUserLoggedInStatus(widget.user.email, false);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GirisEkrani()));
    });
  }

  buildGovde() {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
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
            buildTelefon(),
            SizedBox(
              height: 5.0,
            ),
            buildAdres(),
            SizedBox(
              height: 5.0,
            ),
            buildUpdateButton(),
          ],
        ),
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
        txtBirthDate.text = DateFormat('dd-MM-yyyy').format(selectedDate);
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
          user!.dogumtarihi = txtBirthDate.text;
          user!.email = txtuserName.text;
          user!.password = txtpassWord.text;
          user!.telefon = txtTelefon.text;
          user!.adres = txtAdres.text;
          await dbHelper.updateUser(user!);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeUser(Myuser: widget.user)));
        }
        break;
      default:
    }
  }

  void _showResendDialogupdate() {
    AlertDialog alert = AlertDialog(
      title: Text("Uyarı"),
      content: Text("Kayıt Başarıyla Güncellendi"),
      actions: [
        ElevatedButton(
          child: Text("Tamam"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showResendDialogdelete() {
    AlertDialog alert = AlertDialog(
      title: Text("Uyarı"),
      content: Text("Kayıt Başarıyla Silindi"),
      actions: [
        ElevatedButton(
          child: Text("Tamam"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  buildUpdateButton() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: Color(0xffbf1922),
                          title: Text(
                            "Kaydı Güncelle",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                  "Kaydı güncellemek istediğinize emin misiniz?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "HAYIR",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  user!.ad = txtName.text;
                                  user!.soyad = txtSurname.text;
                                  user!.dogumtarihi = txtBirthDate.text;
                                  user!.email = txtuserName.text;
                                  user!.password = txtpassWord.text;
                                  user!.telefon = txtTelefon.text;
                                  user!.adres = txtAdres.text;
                                  await dbHelper.updateUser(user!);
                                  _showResendDialogupdate();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeUser(Myuser: widget.user)));
                                }
                                setState(() {}); // Liste güncelle
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
              },
              child: Text(
                "Güncelle",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  primary: Color(0xffbf1922)),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Color(0xffbf1922),
                      title: Text(
                        "Kaydı Güncelle",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                              "Kaydı güncellemek istediğinize emin misiniz?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "HAYIR",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await dbHelper.deleteUser(user!.id!);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginUser()));
                            setState(() {}); // Liste güncelle
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
              },
              child: Text(
                "Sil",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  primary: Color(0xffbf1922)),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDeleteDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kaydı Sil'),
          content: Text('Kaydı silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              child: Text('Hayır'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Evet'),
              onPressed: () {
                dbHelper.deleteUser(user.id!); // Şirketi sil
                Navigator.of(context).pop();
                setState(() {}); // Liste güncelle
              },
            ),
          ],
        );
      },
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
