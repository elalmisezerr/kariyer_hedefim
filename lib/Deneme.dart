import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

class RichTextEditorScreen extends StatefulWidget {
  @override
  _RichTextEditorScreenState createState() => _RichTextEditorScreenState();
}

class _RichTextEditorScreenState extends State<RichTextEditorScreen> {
  final _editorController = RichTextEditorController();

  @override
  void initState() {
    super.initState();
    _editorController.addListener(() {
      // Yazı değiştiğinde yapılacak işlemler
    });
  }

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zengin Metin Editörü'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: RichTextField(
                  controller: _editorController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Metin girin...',
                  ),
                  maxLines: null,
                ),
              ),
            ),
            Container(
              height: 50,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.format_bold),
                    onPressed: () {
                      _editorController.selection = TextSelection(
                          baseOffset: _editorController.selection.baseOffset,
                          extentOffset:
                          _editorController.selection.extentOffset);
                      _editorController.toggleBold();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.format_italic),
                    onPressed: () {
                      _editorController.selection = TextSelection(
                          baseOffset: _editorController.selection.baseOffset,
                          extentOffset:
                          _editorController.selection.extentOffset);
                      _editorController.toggleItalic();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.format_underline),
                    onPressed: () {
                      _editorController.selection = TextSelection(
                          baseOffset: _editorController.selection.baseOffset,
                          extentOffset:
                          _editorController.selection.extentOffset);
                      _editorController.toggleUnderline();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
