import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';  // Importação do Firebase Core
import 'package:flutter_finalapp/screens/login_screen.dart';
import 'package:flutter_finalapp/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o Flutter esteja totalmente inicializado
  await Firebase.initializeApp(); // Inicializa o Firebase
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

class WelcomeForm extends StatelessWidget {
  const WelcomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Garantir que o conteúdo seja centralizado
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 100), // Ajuste para centralizar mais
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50), // Tamanho maior para o botão
                  textStyle: const TextStyle(fontSize: 18), // Texto maior
                ),
                child: const Text('Fazer Login'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50), // Tamanho maior para o botão
                  textStyle: const TextStyle(fontSize: 18), // Texto maior
                ),
                child: const Text('Registrar-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
