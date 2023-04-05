import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Screens/BasvuruIslemleri/BasvuruGoruntule.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/AdminAnasayfa.dart';
import 'package:kariyer_hedefim/Validation/ValidationUser.dart';
import '../../Data/DbProvider.dart';
import '../../Models/Company.dart';
import '../../Models/JobAdvertisements.dart';

class IlanDuzenleme extends StatefulWidget {
  Ilanlar? ilanlar;
  Company? company;
  IlanDuzenleme({
    required this.ilanlar,
    required this.company,
    Key? key,
  }) : super(key: key);

  @override
  State<IlanDuzenleme> createState() => _IlanDuzenlemeState(company, ilanlar);
}

enum Options { delete, update }

class _IlanDuzenlemeState extends State<IlanDuzenleme>
    with Useraddvalidationmixin {
  Ilanlar? ilanlar;
  Company? company;
  var formKey = GlobalKey<FormState>();
  var dbHelper = DatabaseProvider();
  var txtBaslik = TextEditingController();
  var txtaciklama = TextEditingController();
  var txtSirketId = TextEditingController();
  var txtTarih = TextEditingController();

  _IlanDuzenlemeState(this.company, this.ilanlar);

  @override
  void initState() {
    txtBaslik.text = ilanlar!.baslik;
    txtaciklama.text = ilanlar!.aciklama;
    txtSirketId.text = ilanlar!.sirket_id.toString();
    txtTarih.text = DateFormat('yyyy-MM-dd').format(ilanlar!.tarih);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade700,
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
              buildUpdateButton(),
              buildBasvuranlarButton(),
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
          validator: validateName,
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
          validator: validateName,
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
    if (widget.company!.id != null) {
      return txtSirketId.text = widget.company!.id.toString();
    } else {
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
          validator: validateBirtdate,
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
  buildUpdateButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate())  {
          formKey.currentState!.save();
          print(ilanlar!.baslik);
          await dbHelper.updateIlan(Ilanlar(
            id: ilanlar!.id,
            baslik: txtBaslik.text,
            aciklama: txtaciklama.text,
            tarih: DateFormat('yyyy-MM-dd').parse(txtTarih.text),
            sirket_id: company!.id,
          ));
        }
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeAdmin(company: company, isLoggedin: false, )));

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
  buildBasvuranlarButton() {
    return TextButton(
      onPressed: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BasvuruGoruntule(ilanlar: ilanlar)));
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
          color: Colors.orange,
        ),
        child: Expanded(
          child: Text(
            "Başvuranları Görüntüle",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void selectProcess(Options options) async {
    switch (options) {
      case Options.delete:
        await dbHelper.deleteIlan(ilanlar!.id!);
        Navigator.pop(context,true);
      break;
      default:
    }
  }
}
