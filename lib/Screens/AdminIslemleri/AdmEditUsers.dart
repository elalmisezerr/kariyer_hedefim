import 'package:flutter/cupertino.dart';

class AdmEditUsers extends StatefulWidget {
  const AdmEditUsers({Key? key}) : super(key: key);

  @override
  State<AdmEditUsers> createState() => _AdmEditUsersState();
}

class _AdmEditUsersState extends State<AdmEditUsers> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "edit users"
      ),
    );
  }
}
