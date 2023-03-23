import 'package:flutter/material.dart';

import '../../Models/User.dart';

class BasvuruGoruntule extends StatefulWidget {
  User? user;
  BasvuruGoruntule({Key? key,required this.user}) : super(key: key);

  @override
  State<BasvuruGoruntule> createState() => _BasvuruGoruntuleState();
}

class _BasvuruGoruntuleState extends State<BasvuruGoruntule> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

        ],
      ),
    );
  }
}
