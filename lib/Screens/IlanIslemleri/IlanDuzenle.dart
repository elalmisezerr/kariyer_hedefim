import 'dart:convert';

import 'package:decorated_dropdownbutton/decorated_dropdownbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Screens/BasvuruIslemleri/BasvuruGoruntule.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/SirketAnasayfa.dart';
import 'package:kariyer_hedefim/Validation/ValidationIlan.dart';
import '../../Data/DbProvider.dart';
import '../../Models/Company.dart';
import '../../Models/JobAdvertisements.dart';
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
  QuillController? _controller;
  var selectedValue = "1";

  _IlanDuzenlemeState(this.company, this.ilanlar);

  @override
  void initState() {
    print(widget.ccontroller?.document.toPlainText());
    print(_controller!.document.toPlainText());
    print(ilanlar!.aciklama);
    txtBaslik.text = ilanlar!.baslik;
    txtaciklama2.text = ilanlar!.aciklama;
    txtSirketId.text = ilanlar!.sirket_id.toString();
    txtTarih.text = ilanlar!.tarih;
    temp = ilanlar!.calisma_zamani.toString();
    selectedValue = ilanlar!.calisma_zamani.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffbf1922),
        title: Text("${widget.ilanlar!.baslik}".toUpperCase()),
        actions: <Widget>[
          PopupMenuButton<Options>(
              onSelected: selectProcess,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
                    const PopupMenuItem<Options>(
                      value: Options.delete,
                      child: Text("Sil"),
                    ),
                  ])
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
              DropdownButon1(),
              buildUpdateButton(),
              buildBasvuranlarButton(),
            ],
          ),
        ),
      ),
    );
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
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => RichTextEditorScreen(
                text: txtaciklama.text,
                company: widget.company,
                controller: widget.ccontroller,
                callback: (QuillController value) { setState(() {
                  print(value.document.toPlainText());
                  txtaciklama2.text = value.document.toPlainText();
                  txtaciklama.text =
                      jsonEncode(value.document.toDelta().toJson());
                  print(txtaciklama.text);
                  //temp =txtaciklama.text;

                });},
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
  QuillController convertJsonToQuillController(String jsonString) {
    var jsonMap = jsonDecode(jsonString);
    Document doc = Document.fromJson(jsonMap);
    QuillController controller = QuillController(document: doc, selection:TextSelection(
      baseOffset: 0,
      extentOffset: doc.length,
    ));
    return controller;
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

  DropdownButon1() {
    return DecoratedDropdownButton(
      value: selectedValue,
      items: [
        DropdownMenuItem(child: Text("Tam Zamanlı"), value: "1"),
        DropdownMenuItem(child: Text("Yarı Zamanlı"), value: "2"),
        DropdownMenuItem(child: Text("Her İkisi"), value: "3")
      ],
      onChanged: (value) {
        setState(() {
          selectedValue = value.toString();
          temp = value.toString();
        });
      },
      color: Color(0xffbf1922), //background colorer
      borderRadius: BorderRadius.circular(20), //border radius
      style: TextStyle(
          //text style
          color: Colors.white,
          fontSize: 20),
      icon: Icon(Icons.arrow_downward), //icon
      iconEnableColor: Colors.white, //icon enable color
      dropdownColor: Color(0xffbf1922), //dropdown background color
    );
  }

  //Tarih seçici
  Future<void> _showDatePicker() async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2025));
    if (selectedDate != null) {
      setState(() {
        txtTarih.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  //Kaydetme butonu
  buildUpdateButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          print(ilanlar!.baslik);
          await dbHelper.updateIlan(Ilanlar(
            id: ilanlar!.id,
            baslik: txtBaslik.text,
            aciklama: txtaciklama.text,
            tarih: txtTarih.text,
            sirket_id: company!.id,
            calisma_zamani: int.parse(temp!),
            //kategori: "",
          ));
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeCompany(
                      company: company,
                      isLoggedin: false,
                    )));
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
          color: Color(0xffbf1922),
        ),
        child: Text(
          "Güncelle",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  buildBasvuranlarButton() {
    return TextButton(
      onPressed: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BasvuruGoruntule(ilanlar: ilanlar)));
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
          color: Color(0xffbf1922),
        ),
        child: Text(
          "Başvuranları Görüntüle",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
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
