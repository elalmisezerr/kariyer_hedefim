import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Models/JobAdvertisements.dart';

import '../../Models/User.dart';

class IlanDetay extends StatefulWidget {
  Ilanlar? ilanlar;
  User? user;
  IlanDetay({Key? key,required this.ilanlar,required this.user}) : super(key: key);

  @override
  State<IlanDetay> createState() => _IlanDetayState();
}

class _IlanDetayState extends State<IlanDetay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İlan Detay"),

      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){

            }, child: Text("Başvur"))
          ],
        ),
      ),
    );
  }
}
