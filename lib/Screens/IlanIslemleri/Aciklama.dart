import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:kariyer_hedefim/Screens/IlanIslemleri/%C4%B0lanEkleme.dart';

import '../../Models/Company.dart';

class RichTextEditorScreen extends StatelessWidget {
  RichTextEditorScreen({required this.text,required this.company,Key? key, required this.callback}) : super(key: key);
  Company? company;
  QuillController _controller = QuillController.basic();
  String? text;
   ValueChanged<String>? callback=_emtyfunction;

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
          Center(
            child: Expanded(
              flex: 1,
              child: QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode

              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:Color(0xffbf1922) ,
        onPressed: (){
          String? quillText = jsonEncode(_controller.document.toDelta().toJson());
          callback!(quillText);
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
    ),
    );
  }

  static void _emtyfunction(String value) {}
}






// import 'package:flutter/material.dart';
// import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';
//
// class RichTextEditorScreen extends StatefulWidget {
//   @override
//   _RichTextEditorScreenState createState() => _RichTextEditorScreenState();
// }
//
// class _RichTextEditorScreenState extends State<RichTextEditorScreen> {
//   final _editorController = RichTextEditorController();
//
//   @override
//   void initState() {
//     super.initState();
//     _editorController.addListener(() {
//       // Yazı değiştiğinde yapılacak işlemler
//     });
//   }
//
//   @override
//   void dispose() {
//     _editorController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Zengin Metin Editörü'),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 child: RichTextField(
//                   controller: _editorController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Metin girin...',
//                   ),
//                   maxLines: null,
//                 ),
//               ),
//             ),
//             Container(
//               height: 50,
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.format_bold),
//                     onPressed: () {
//                       _editorController.selection = TextSelection(
//                           baseOffset: _editorController.selection.baseOffset,
//                           extentOffset:
//                           _editorController.selection.extentOffset);
//                       _editorController.toggleBold();
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.format_italic),
//                     onPressed: () {
//                       _editorController.selection = TextSelection(
//                           baseOffset: _editorController.selection.baseOffset,
//                           extentOffset:
//                           _editorController.selection.extentOffset);
//                       _editorController.toggleItalic();
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.format_underline),
//                     onPressed: () {
//                       _editorController.selection = TextSelection(
//                           baseOffset: _editorController.selection.baseOffset,
//                           extentOffset:
//                           _editorController.selection.extentOffset);
//                       _editorController.toggleUnderline();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
