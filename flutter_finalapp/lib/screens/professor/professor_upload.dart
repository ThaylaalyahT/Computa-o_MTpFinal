import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalapp/models/user_model.dart';

class ProfessorUploadScreen extends StatefulWidget {
  final AppUser user;

  const ProfessorUploadScreen({super.key, required this.user});

  @override
  _ProfessorUploadScreenState createState() => _ProfessorUploadScreenState();
}

class _ProfessorUploadScreenState extends State<ProfessorUploadScreen> {
  bool _isUploading = false;
  String _statusMessage = '';

  Future<void> _uploadFile() async {
    setState(() {
      _isUploading = true;
      _statusMessage = 'Aguardando seleção de arquivo...';
    });

    // Abrir o seletor de arquivos
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = result.files.single;

      setState(() {
        _statusMessage = 'Enviando: ${file.name}';
      });

      // Enviar para o Firebase Storage
      try {
        final storageRef = FirebaseStorage.instance.ref().child('uploads/${widget.user.uid}/${file.name}');
        await storageRef.putData(file.bytes!);

        setState(() {
          _statusMessage = 'Arquivo enviado com sucesso!';
        });
      } catch (e) {
        setState(() {
          _statusMessage = 'Erro ao enviar arquivo: $e';
        });
      }
    } else {
      setState(() {
        _statusMessage = 'Nenhum arquivo selecionado.';
      });
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload de Arquivos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadFile,
              child: _isUploading ? const CircularProgressIndicator() : const Text('Selecionar e Enviar Arquivo'),
            ),
            const SizedBox(height: 20),
            Text(_statusMessage),
          ],
        ),
      ),
    );
  }
}
