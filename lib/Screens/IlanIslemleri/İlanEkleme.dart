import 'package:decorated_dropdownbutton/decorated_dropdownbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/intl.dart';
import 'package:kariyer_hedefim/Components/MyDrawer.dart';
import 'package:kariyer_hedefim/Data/DbProvider.dart';
import 'package:kariyer_hedefim/Models/Company.dart';
import 'package:kariyer_hedefim/Models/JobAdvertisements.dart';
import 'package:kariyer_hedefim/Screens/SirketIslemleri/SirketAnasayfa.dart';
import 'package:kariyer_hedefim/Validation/ValidationIlan.dart';

import '../GirisEkranı.dart';

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
  var selectedValue='1';
  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  String? temp;

@override
void initState() {
    setState(() {
      buildSirketId();
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
      drawer: MyDrawerComp(company: widget.company!,),
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
            IconButton(onPressed: logout, icon: Icon(Icons.logout))
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
                SizedBox(height: 15,),
                DrpMenu(),
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
  buildBaslik2() {
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
  buildBaslik() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: TextFormField(
        validator: validateBaslik,
        controller: txtBaslik,
        decoration: InputDecoration(

            prefixIcon: Icon(Icons.person,color: Color(0xffbf1922),),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color:Color(0xffbf1922))
            ),
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
  }  buildAciklama() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10,bottom: 20),
      child: TextFormField(
        maxLines: 3,
        validator: validateAciklama,
        controller: txtaciklama,
        decoration: InputDecoration(

            prefixIcon: Icon(Icons.person,color: Color(0xffbf1922),),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color:Color(0xffbf1922))
            ),
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
   if(widget.company!.id!=null ) {
   return txtSirketId.text = widget.company!.id.toString();
    }else{
     return null;
   }
  }
  Widget buildTarih() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: TextField(
        onTap: _showDatePicker,
        controller: txtTarih,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.calendar_month,color: Color(0xffbf1922),),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color:Color(0xffbf1922))
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color:Color(0xffbf1922)),
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
        txtTarih.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }
  void logout() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GirisEkrani()));
    });
  }

  DrpMenu(){
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: DecoratedDropdownButton(
        value: selectedValue,
        items: [
          DropdownMenuItem(
              child: Text("Tam Zamanlı"),
              value: "1"
          ),

          DropdownMenuItem(
              child: Text("Yarı Zamanlı"),
              value: "2"
          ),
          DropdownMenuItem(
              child: Text("Her İkisi"),
              value: "3"
          )
        ],
        onChanged: (value) {
          setState(() {
            selectedValue = value.toString();
            temp = value.toString();
          });
        },

        color: Color(0xffbf1922), //background color //border
        borderRadius: BorderRadius.circular(10), //border radius
        style: TextStyle( //text style
            color:Colors.white,
            fontSize: 20
        ),
        icon: Icon(Icons.arrow_downward), //icon
        iconEnableColor: Colors.white, //icon enable color
        dropdownColor: Color(0xffbf1922),  //dropdown background color
      ),
    );
  }

  //Kaydetme butonu
  buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: TextButton(
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
            color: Color(0xffbf1922),

          ),
          child: Text("Ekle",
            style: TextStyle(fontSize: 20,color: Colors.white),),

        ),


      ),
    );
  }

  //Kaydetme işlemini sağlayan fonksiyon
  void addIlan() async {
    var result = await dbHelper.insertIlan(Ilanlar.withOutId(
      baslik: txtBaslik.text,
      aciklama: txtaciklama.text,
      sirket_id: int.parse(txtSirketId.text),
      tarih: DateFormat('dd-MM-yyyy').parse(txtTarih.text),
      calisma_zamani: int.parse(temp ?? "1"),
      //kategori: "",
      ));
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeCompany(company: widget.company, isLoggedin: true,)));
  }
}
