// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Card extends StatelessWidget {
  const Card({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          height: height*0.7,
          width: width*0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors:[
                Colors.amber,
                Colors.yellow,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
