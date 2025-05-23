import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_finalapp/screens/login_screen.dart';
import 'package:flutter_finalapp/screens/register_screen.dart';
import 'package:flutter_finalapp/screens/aluno/aluno_dashboard.dart';
import 'package:flutter_finalapp/screens/professor/professor_dashboard.dart';
import 'package:flutter_finalapp/screens/discipline_screen.dart';
import 'package:flutter_finalapp/screens/registar_disciplina.dart';
import 'package:flutter_finalapp/screens/aluno/aluno_upload.dart';
import 'package:flutter_finalapp/screens/professor/professor_upload.dart' as upload;
import 'package:flutter_finalapp/screens/professor/registar_tarefa_screen.dart' as registrar;

import 'package:flutter_finalapp/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FormulÃ¡rio Flutter',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const WelcomeForm(),
        '/login': (ctx) => const LoginScreen(),
        '/register': (ctx) => const RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/aluno_dashboard') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (_) => AlunoDashboard(user: user),
          );
        }

        if (settings.name == '/professor_dashboard') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (_) => ProfessorDashboard(user: user),
          );
        }

        if (settings.name == '/disciplinas') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (_) => DisciplineScreen(user: user),
          );
        }

        if (settings.name == '/registrar_disciplina') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (_) => RegistarDisciplinaScreen(user: user),
          );
        }

        if (settings.name == '/aluno_upload') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (_) => AlunoUploadScreen(user: user),
          );
        }

        if (settings.name == '/professor_upload') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (_) => registrar.RegistarTarefaScreen(
              user: user,
              professorId: user.uid,
            ),
          );
        }

        if (settings.name == '/registrar_tarefa') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (_) => upload.RegistarTarefaScreen(professorId: user.uid,
                user: user),
          );
        }

        return null;
      },
    );
  }
}

class WelcomeForm extends StatelessWidget {
  const WelcomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/learnly_logo.png', width: 100),
              const Text(
                'Learnly!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Fazer Login'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text('Registar-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}