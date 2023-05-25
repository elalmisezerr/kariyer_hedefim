import 'dart:convert';

import 'package:decorated_dropdownbutton/decorated_dropdownbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/Kurum.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/SirketAnasayfa.dart';
import 'package:kariyer_hedefim/Validation/ValidationIlan.dart';

import '../../Models/Ilan.dart';
import '../GirisEkranı.dart';
import 'Aciklama.dart';

class IlanEkle extends StatefulWidget {
  Company? company;
  QuillController? ccontroller;

  IlanEkle({Key? key, required this.company, this.ccontroller})
      : super(key: key);

  @override
  State<IlanEkle> createState() => _IlanEkleState();
}

class _IlanEkleState extends State<IlanEkle> with IlanValidationMixin {
  var formKey = GlobalKey<FormState>();
  var dbHelper = DatabaseProvider();
  TextEditingController? txtBaslik = TextEditingController();
  TextEditingController? txtaciklama = TextEditingController();
  TextEditingController? txtaciklama2 = TextEditingController();
  TextEditingController? txtSirketId = TextEditingController();
  TextEditingController? txtTarih = TextEditingController();
  String? selectedValue = "1";
  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  @override
  void initState() {
    setState(() {
      buildSirketId();
      txtaciklama2 = TextEditingController();
    });
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
      drawer: MyDrawerComp(
        company: widget.company!,
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
          title: Text("İlan Ekleme Sayfası"),
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
                              onPressed: () => Navigator.of(context).pop(false),
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
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: ListView(
              children: [
                buildBaslik(),
                SizedBox(),
                buildAciklama(),
                buildTarih(),
                SizedBox(
                  height: 15,
                ),
                //DrpMenu(),
                checkBox(context),
                SizedBox(),
                buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Başlık Formu
  buildBaslik() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: TextFormField(
        validator: validateBaslik,
        controller: txtBaslik,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: Color(0xffbf1922),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xffbf1922))),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Color(0xffbf1922)),
            ),
            hintText: "Başlık Giriniz",
            labelText: "Başlık",
            labelStyle: TextStyle(color: Color(0xffbf1922)),
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.green,
      ),
    );
  }

  //Açıklama Formu
  buildAciklama() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: TextFormField(
        onTap: () {
          Map<String, dynamic> quillMap;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RichTextEditorScreen(
                        text: txtaciklama!.text,
                        company: widget.company,
                        controller: widget.ccontroller,
                        callback: (QuillController value) {
                          setState(() {
                            print(value.document.toPlainText());
                            txtaciklama2!.text = value.document.toPlainText();
                            txtaciklama!.text =
                                jsonEncode(value.document.toDelta().toJson());
                            print(txtaciklama!.text);
                            //temp =txtaciklama.text;
                          });
                        },
                      )));
        },
        readOnly: true,
        maxLines: 3,
        validator: validateAciklama,
        controller: txtaciklama2,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: Color(0xffbf1922),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xffbf1922))),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Color(0xffbf1922)),
            ),
            hintText: "Açıklama Giriniz",
            labelText: "Açıklama",
            labelStyle: TextStyle(color: Color(0xffbf1922)),
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.green,
      ),
    );
  }

  //Şirket Id Ekleme Kısmı
  buildSirketId() {
    if (widget.company!.id != null) {
      return txtSirketId!.text = widget.company!.id.toString();
    } else {
      return null;
    }
  }

  //Tarih Formu
  Widget buildTarih() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: TextField(
        onTap: _showDatePicker,
        controller: txtTarih,
        readOnly: true,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.calendar_month,
              color: Color(0xffbf1922),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xffbf1922))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffbf1922)),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Tarih Seçiniz",
            labelText: "Tarih",
            labelStyle: TextStyle(color: Color(0xffbf1922)),
            filled: true,
            fillColor: Colors.white),
        cursorColor: Colors.red,
      ),
    );
  }

  //Tarih seçici
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
        txtTarih!.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  //Çıkış Fonsiyonu
  void logout() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GirisEkrani()));
    });
  }


  bool _value1 = false;
  bool _value2 = false;
  bool _value3 = false;

  Widget checkBox(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CheckboxListTile(
          value: _value1,
          onChanged: (bool? value) {
            setState(() {
              _value1 = value!;
              if (_value1) {
                selectedValue = "1";
                _value2 = false;
                _value3 = false;
              }
            });
          },
          title: Text('Tam Zamanlı'),
        ),
        CheckboxListTile(
          value: _value2,
          onChanged: (bool? value) {
            setState(() {
              _value2 = value!;
              if (_value2) {
                selectedValue = "2";
                _value1 = false;
                _value3 = false;
              }
            });
          },
          title: Text('Yarı Zamanlı'),
        ),
        CheckboxListTile(
          value: _value3,
          onChanged: (bool? value) {
            setState(() {
              _value3 = value!;
              if (_value3) {
                selectedValue = "3";
                _value1 = true;
                _value2 = true;
              } else {
                _value1 = false;
                _value2 = false;
              }
            });
          },
          title: Text('Her İkisi'),
        ),
      ],
    );
  }

  //Kaydetme butonu
  buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            addIlan();
          }
        },
        child: Text(
          "Ekle",
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

  //Kaydetme işlemini sağlayan fonksiyon
  void addIlan() async {
    var result = await dbHelper.insertIlan(Ilanlar.withOutId(
      baslik: txtBaslik!.text,
      aciklama: txtaciklama!.text,
      sirket_id: int.parse(txtSirketId!.text),
      tarih: txtTarih!.text,
      calisma_zamani: int.parse(selectedValue ?? "1"),
      //kategori: "",
    ));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeCompany(
                  company: widget.company,
                  isLoggedin: true,
                )));
  }
}
