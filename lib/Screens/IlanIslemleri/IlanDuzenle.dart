import 'dart:convert';
import 'package:decorated_dropdownbutton/decorated_dropdownbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Screens/BasvuruIslemleri/BasvuruGoruntule.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/SirketAnasayfa.dart';
import 'package:kariyer_hedefim/Validation/ValidationIlan.dart';
import '../../Data/DbProvider.dart';
import '../../Models/Ilan.dart';
import '../../Models/Kurum.dart';
import 'Aciklama.dart';

class IlanDuzenleme extends StatefulWidget {
  Ilanlar? ilanlar;
  Company? company;
  QuillController? ccontroller;
  IlanDuzenleme({
    required this.ilanlar,
    required this.company,
    this.ccontroller,
    Key? key,
  }) : super(key: key);

  @override
  State<IlanDuzenleme> createState() => _IlanDuzenlemeState(company, ilanlar);
}

enum Options { delete, update }

class _IlanDuzenlemeState extends State<IlanDuzenleme>
    with IlanValidationMixin {
  Ilanlar? ilanlar;
  Company? company;
  var formKey = GlobalKey<FormState>();
  var dbHelper = DatabaseProvider();
  var txtBaslik = TextEditingController();
  var txtaciklama = TextEditingController();
  var txtaciklama2 = TextEditingController();
  var txtSirketId = TextEditingController();
  var txtTarih = TextEditingController();
  var temp;
  var tempskli;
  var selectedValue = "1";
  var selectedValue2 = "1";
  _IlanDuzenlemeState(this.company, this.ilanlar);

  @override
  void initState() {
    widget.ccontroller = convertJsonToQuillController(ilanlar!.aciklama);
    txtBaslik.text = ilanlar?.baslik ?? '';
    txtaciklama.text = ilanlar!.aciklama;
    txtaciklama2.text =
        convertJsonToQuillController(ilanlar!.aciklama).document.toPlainText();
    txtSirketId.text = ilanlar?.sirket_id?.toString() ?? '';
    txtTarih.text = ilanlar?.tarih ?? '';
    temp = ilanlar?.calisma_zamani.toString() ?? '';
    tempskli = ilanlar?.calisma_sekli.toString() ?? '';
    selectedValue = ilanlar?.calisma_zamani.toString() ?? '';
    selectedValue2 = ilanlar?.calisma_sekli.toString() ?? '';

    if (temp == '1') {
      _value1 = true;
    } else if (temp == '2') {
      _value2 = true;
    } else if (temp == '3') {
      _value1 = true;
      _value2 = true;
      _value3 = true;
    }    if (temp == '1') {
      _value1 = true;
    } else if (temp == '2') {
      _value2 = true;
    } else if (temp == '3') {
      _value1 = true;
      _value2 = true;
      _value3 = true;
    }
    if (tempskli == '1') {
      online = true;
    } else if (tempskli == '2') {
      yuzyuze = true;
    } else if (tempskli == '3') {
      online = true;
      yuzyuze = true;
      hibrit = true;
    }    if (tempskli == '1') {
      online = true;
    } else if (tempskli == '2') {
      yuzyuze = true;
    } else if (tempskli == '3') {
      online = true;
      yuzyuze = true;
      hibrit = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffbf1922),
        title: Text("${widget.ilanlar!.baslik}".toUpperCase()),

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
              checkBox(context),
              SizedBox(
                height: 10,
              ),checkBox2(context),
              SizedBox(
                height: 10,
              ),
              buildUpdateButton(),
              buildBasvuranlarButton(),
            ],
          ),
        ),
      ),
    );
  }

  QuillController convertJsonToQuillController(String jsonString) {
    if (jsonString.isEmpty) {
      // Handle the empty JSON string case
      return QuillController
          .basic(); // Or throw an exception, depending on your requirements
    }

    var jsonMap = jsonDecode(jsonString);
    Document doc = Document.fromJson(jsonMap);
    QuillController controller = QuillController(
        document: doc,
        selection: TextSelection(
          baseOffset: 0,
          extentOffset: doc.length,
        ));
    return controller;
  }

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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RichTextEditorScreen(
                        text: txtaciklama.text,
                        company: widget.company,
                        controller: widget.ccontroller,
                        callback: (QuillController value) {
                          setState(() {
                            print(value.document.toPlainText());
                            txtaciklama2.text = value.document.toPlainText();
                            txtaciklama.text =
                                jsonEncode(value.document.toDelta().toJson());
                            print(txtaciklama.text);
                            //temp =txtaciklama.text;
                          });
                        },
                      )));
        },
        maxLines: 3,
        validator: validateAciklama,
        readOnly: true,
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

  //Şirket Id Formu
  buildSirketId() {
    if (widget.company!.id != null) {
      return txtSirketId.text = widget.company!.id.toString();
    } else {
      return null;
    }
  }

  //Tarih formu
  Widget buildTarih() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: TextField(
        onTap: _showDatePicker,
        controller: txtTarih,
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
    final ThemeData datePickerTheme = ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(
        primary:Color(0xffbf1922), // Set the primary color to red
        onPrimary: Colors.white,
      ),
    );


    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2025),
      locale: const Locale('tr', 'TR'), // Türkçe dil desteği ekledik
      builder: (BuildContext context, Widget? child) {
      return Theme(
        data: datePickerTheme,
        child: child!,
      );
    },
    );
    if (selectedDate != null) {
      setState(() {
        txtTarih.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  //Kaydetme butonu
  bool _value1 = false;
  bool _value2 = false;
  bool _value3 = false;

  Widget checkBox(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color:Color(0xffbf1922)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: CheckboxListTile(
                activeColor: Color(0xffbf1922),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.all(0),
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
                title: Text(
                  'Tam Zamanlı',
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xffbf1922)
                  ),
                  overflow: TextOverflow.visible,
                  maxLines: 3,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: CheckboxListTile(
                activeColor: Color(0xffbf1922),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.only(left:0, right:0, top: 4.0, bottom: 4.0),
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
                title: Text(
                  'Yarı Zamanlı',
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xffbf1922)
                  ),
                  overflow: TextOverflow.visible,
                  maxLines: 3,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: CheckboxListTile(
                activeColor: Color(0xffbf1922),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.all(0),
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
                title: Text(
                  'Her İkisi',
                  style: TextStyle(
                      fontSize: 17,
                      color: Color(0xffbf1922)
                  ),
                  overflow: TextOverflow.visible,
                  maxLines: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool online = false;
  bool yuzyuze = false;
  bool hibrit = false;

  Widget checkBox2(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color:Color(0xffbf1922)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: CheckboxListTile(
                activeColor: Color(0xffbf1922),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.all(0),
                value: online,
                onChanged: (bool? value) {
                  setState(() {
                    online = value!;
                    if (online) {
                      selectedValue2 = "1";
                      yuzyuze = false;
                      hibrit = false;
                    }
                  });
                },
                title: Text(
                  'Online',
                  style: TextStyle(
                    color: Color(0xffbf1922),
                  ),
                  overflow: TextOverflow.visible,
                  maxLines: 3,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: CheckboxListTile(
                activeColor: Color(0xffbf1922),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.all(0),
                value: yuzyuze,
                onChanged: (bool? value) {
                  setState(() {
                    yuzyuze = value!;
                    if (yuzyuze) {
                      selectedValue2 = "2";
                      online = false;
                      hibrit = false;
                    }
                  });
                },
                title: Text(
                  'Yüzyüze',
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xffbf1922)
                  ),
                  overflow: TextOverflow.visible,
                  maxLines: 3,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: CheckboxListTile(
                activeColor: Color(0xffbf1922),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.all(0),
                value: hibrit,
                onChanged: (bool? value) {
                  setState(() {
                    hibrit = value!;
                    if (hibrit) {
                      selectedValue2 = "3";
                      online = true;
                      yuzyuze = true;
                    } else {
                      online = false;
                      yuzyuze = false;
                    }
                  });
                },
                title: Text(
                  'Hibrit',
                  style: TextStyle(
                      color: Color(0xffbf1922)
                  ),
                  overflow: TextOverflow.visible,
                  maxLines: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Kaydetme butonu
  buildUpdateButton() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor:Color(0xffbf1922),
                    title: Text('Kaydı Güncelle',textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white),),
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
                    actions: [
                      TextButton(
                        child: Text('HAYIR',style: TextStyle(
                          color: Colors.white,
                        ),),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('EVET',style: TextStyle(
                          color: Colors.white,
                        ),),
                        onPressed: () async {
                          Ilanlar updatedIlan;
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            if (ilanlar!.baslik != txtBaslik.text ||
                                ilanlar!.aciklama != txtaciklama.text ||
                                ilanlar!.tarih != txtTarih.text ||
                                company!.id != ilanlar!.sirket_id ||
                                int.parse(temp!) != ilanlar!.calisma_zamani) {
                              updatedIlan = Ilanlar(
                                id: ilanlar!.id,
                                baslik: txtBaslik.text,
                                aciklama: txtaciklama.text,
                                tarih: txtTarih.text,
                                sirket_id: company!.id,
                                calisma_zamani: int.parse(temp!),
                                calisma_sekli: int.parse(tempskli!),
                              );
                            } else {
                              updatedIlan = ilanlar!;
                            }
                            await dbHelper.updateIlan(updatedIlan);
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeCompany(
                                    company: company,
                                    isLoggedin: false,
                                  )));
                          setState(() {}); // Liste güncelle
                        },
                      ),
                    ],
                  );
                },
              );

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
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor:Color(0xffbf1922),
                    title: Text('Kaydı Sil',textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white),),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                            "Kaydı silmek istediğinize emin misiniz?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text('HAYIR',style: TextStyle(
                          color: Colors.white,
                        ),),

                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('EVET',style: TextStyle(
                  color: Colors.white,
                  ),),
                        onPressed: () async {
                          await dbHelper.deleteIlan(ilanlar!.id!);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeCompany(
                                    company: widget.company,
                                    isLoggedin: true,
                                  )));
                          setState(() {}); // Liste güncelle
                        },
                      ),
                    ],
                  );
                },
              );

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
    );
  }

  buildBasvuranlarButton() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BasvuruGoruntule(ilanlar: ilanlar)));
        },
        child: Text(
          "Başvuranları Görüntüle",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: Color(0xffbf1922)),
      ),
    );
  }

  void selectProcess(Options options) async {
    switch (options) {
      case Options.delete:
        await dbHelper.deleteIlan(ilanlar!.id!);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeCompany(
                      company: widget.company,
                      isLoggedin: true,
                    )));
        break;
      default:
    }
  }
}
