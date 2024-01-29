import 'package:textscanapp/main.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';

class MyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultat'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyApp())); // Utiliser pop pour revenir en arrière
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TexteRecup(
                    text: 'Text to translate',
                  ),
                ),
              );
            },
            child: Text('Go to Result'),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox.shrink(),
      ),
    );
  }
}

class TexteRecup extends StatelessWidget {
  final String text;

  Future<void> _shareTexte(String texte) async {
    await Share.share(texte);
  }

  const TexteRecup({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Text(text),
            ElevatedButton(
              onPressed: () {
                _shareTexte(text);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.share),
                  SizedBox(width: 8.0),
                  Text('Partager le texte'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> retrieveTextFromImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final image = InputImage.fromFilePath(pickedFile.path);
        final textRecognizer = TextRecognizer();
        final recognizedText = await textRecognizer.processImage(image);

        return recognizedText.text;
      } else {
        return 'No image selected.';
      }
    } catch (e) {
      return 'Error retrieving text.';
    }
  }
}
