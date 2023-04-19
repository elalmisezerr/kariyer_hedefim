import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kariyer_hedefim/Models/Company.dart';

import '../../Data/DbProvider.dart';

class AdmEditCompany extends StatefulWidget {
  const AdmEditCompany({Key? key}) : super(key: key);

  @override
  State<AdmEditCompany> createState() => _AdmEditCompanyState();
}

class _AdmEditCompanyState extends State<AdmEditCompany> {
  var dbHelper = DatabaseProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Şirketler"),
      ),
      body: Container(
        child:FutureBuilder<List<Company>>(
          future: dbHelper.getCompanies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}',style: TextStyle(fontSize: 10),),);
            } else {
              final companies = snapshot.data ?? [];
              return buildUserList(companies);
            }
          },
        ),
      ),
    );
  }
  ListView buildUserList(final List<Company> company) {
    return ListView.builder(
      itemCount: company.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/512/146/146877.png?w=826&t=st=1680174675~exp=1680175275~hmac=0cf57b40d3b8182f9a40914db3ced05391c22e3eeb992057cb74d8fd9c0d9a3d',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company[position].isim,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 19.0,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        company[position].email,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 19.0,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        company[position].telefon,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Icon(
                        Icons.home,
                        size: 19.0,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        company[position].adres,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }

}
