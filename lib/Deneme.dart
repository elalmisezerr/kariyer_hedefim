import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class Deneme extends StatelessWidget {
  var email=TextEditingController();
  var body=TextEditingController();
  var subject=TextEditingController();
  sendEmail (String subject, String body, String recipientemail) async {
    final Email email = Email(
    body: body,
    subject: subject,
    recipients: [recipientemail],
// cc: ['cc@example.com'],
// bcc: ['bcc@example.com'],
// attachmentPaths: ['/path/to/attachment.zip'],
    isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }


  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'enter email',
                  border: OutlineInputBorder(),
                ), // Input Decoration
              ), // TextField
              TextFormField(
                controller: subject,
                decoration: InputDecoration(
                  hintText: 'enter subject',
                  border: OutlineInputBorder(),
                ), // InputDecoration
              ), // TextField
              TextFormField(
                controller: body,
                decoration: InputDecoration(
                  hintText: 'enter body',
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    _key.currentState!.save();
                    print('${email.text}');
                    sendEmail(subject.text, body.text, email.text);
                  },
                  child: Text('send email')), // ElevatedButton
            ],
          ),
        ), // Column
      ),
    );
  }
}
