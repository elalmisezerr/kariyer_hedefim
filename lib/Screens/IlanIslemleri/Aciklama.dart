import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import '../../Models/Kurum.dart';

class RichTextEditorScreen extends StatefulWidget {
  RichTextEditorScreen({required this.controller,required this.text,required this.company,Key? key, required this.callback}) : super(key: key);
  Company? company;
  String? text;
  QuillController? controller;
   ValueChanged<QuillController> callback;

  @override
  State<RichTextEditorScreen> createState() => _RichTextEditorScreenState();

}

class _RichTextEditorScreenState extends State<RichTextEditorScreen> {
   QuillController _controller = QuillController.basic();

   @override
   void initState() {
     super.initState();
     _controller = widget.controller ?? QuillController.basic();
     if (widget.text != null && widget.text!.isNotEmpty) {
       final delta = Delta.fromJson(jsonDecode(widget.text!));
       _controller.document = Document.fromDelta(delta);
       // _controller.addListener(() {
       //   setState(() {
       //     // Reset selection when content changes
       //     _controller.updateSelection(
       //       TextSelection.collapsed(offset: _controller.document.length),
       //       ChangeSource.LOCAL,
       //     );
       //   });
       // });


     }
   }


   void convertJson(String incomingJSONText){

     var myJSON = jsonDecode(incomingJSONText);

     _controller = QuillController(document: Document.fromJson(myJSON),
         selection: TextSelection.collapsed(offset: 0));  }

   QuillController convertJsonToQuillController(String jsonString) {
     var jsonMap = jsonDecode(jsonString);
     Document doc = Document.fromJson(jsonMap);
     QuillController controller = QuillController(document: doc, selection:TextSelection(
       baseOffset: 0,
       extentOffset: doc.length,
     ));
     return controller;
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffbf1922),
        title: Text("Lütfen açıklamayı giriniz"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          QuillToolbar.basic(controller: _controller,multiRowsDisplay: false,),
          Expanded(
            flex: 1,
            child: QuillEditor.basic(
              controller: _controller,
              readOnly: false, // true for view only mode

            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:Color(0xffbf1922) ,
        onPressed: (){
          widget.callback(_controller);
        Navigator.pop(context);
      },
        child: Icon(Icons.save),
    ),
    );
  }
}
