import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário Flutter',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const WelcomeForm(),
    );
  }
}

class WelcomeForm extends StatefulWidget {
  const WelcomeForm({super.key});

  @override
  State<WelcomeForm> createState() => _WelcomeFormState();
}

class _WelcomeFormState extends State<WelcomeForm> {
  final TextEditingController _controller = TextEditingController();
  String _name = '';

  void _updateName() {
    setState(() {
      _name = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Digite seu nome:',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Ex: Thayla',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateName,
              child: const Text('Enviar'),
            ),
            const SizedBox(height: 20),
            Text(
              _name.isEmpty ? '' : 'Olá, $_name!',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
