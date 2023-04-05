import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/Company.dart';
import 'package:kariyer_hedefim/Models/JobAdvertisements.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/AdminAnasayfa.dart';
import 'package:kariyer_hedefim/Validation/ValidationIlan.dart';

class IlanEkle extends StatefulWidget {
  Company? company;
  IlanEkle({Key? key,required this.company}) : super(key: key);

  @override
  State<IlanEkle> createState() => _IlanEkleState();
}

class _IlanEkleState extends State<IlanEkle> with IlanValidationMixin{
  var formKey = GlobalKey<FormState>();
  var dbHelper=DatabaseProvider();
  var txtBaslik=TextEditingController();
  var txtaciklama=TextEditingController();
  var txtSirketId=TextEditingController();
  var txtTarih=TextEditingController();

@override
void initState() {
    setState(() {
      buildSirketId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Text("İlan ekleme sayfası"),
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
              buildSaveButton(),

            ],
          ),
        ),
      ),
    );
  }
  //Başlık Formu
  buildBaslik() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Başlık giriniz",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          validator: validateBaslik,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          controller: txtBaslik,
        )
      ],
    );
  }

  //Açıklama Formu
  buildAciklama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Açıklamayı giriniz",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          validator: validateAciklama,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.textsms_outlined),
          ),
          controller: txtaciklama,
        )
      ],
    );
  }

  //Şirket Id Formu
  buildSirketId() {
   if(widget.company!.id!=null ) {
   return txtSirketId.text = widget.company!.id.toString();
    }else{
     return null;
   }
  }

  //Tarih formu
  buildTarih() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tarihinizi seçin",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          validator: validateTarih,
          readOnly: true,
          onTap: _showDatePicker,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.watch_later),
          ),
          controller: txtTarih, // değiştirildi
        )
      ],
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
        txtTarih.text =
            (DateFormat('yyyy-MM-dd').format(selectedDate)).toString();
      });
    }
  }

  //Kaydetme butonu
  buildSaveButton() {
    return TextButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          addIlan();
        }},
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 15,horizontal: 25),
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black,
                offset: Offset(2,4),
                blurRadius: 5,
                spreadRadius: 2),
          ],
          color: Colors.grey.shade700,

        ),
        child: Text("Ekle",
          style: TextStyle(fontSize: 20,color: Colors.white),),

      ),


    );
  }

  //Kaydetme işlemini sağlayan fonksiyon
  void addIlan() async {
    var result = await dbHelper.insertIlan(Ilanlar.withOutId(
      baslik: txtBaslik.text,
      aciklama: txtaciklama.text,
      sirket_id: int.parse(txtSirketId.text),
      tarih: DateFormat('yyyy-MM-dd').parse(txtTarih.text),
      ));
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeAdmin(company: widget.company, isLoggedin: true,)));
  }
}
