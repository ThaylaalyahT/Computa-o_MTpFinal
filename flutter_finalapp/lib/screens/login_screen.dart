import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'aluno/aluno_dashboard.dart';
import 'professor/professor_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _authService = AuthService();

  String email = '';
  String password = '';

  // Função para login com Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // O usuário cancelou o login
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = await _authService.getUserData(userCredential.user!.uid);

      // Navegar para o dashboard do aluno ou professor baseado no tipo
      if (user != null) {
        if (user.type == 'aluno') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AlunoDashboard(user: user)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfessorDashboard(user: user)),
          );
        }
      }
    } catch (e) {
      print('Erro ao fazer login com o Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (val) => email = val,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
              onChanged: (val) => password = val,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final user = await _authService.loginWithEmail(email, password);
                  if (user != null) {
                    final userData = await _authService.getUserData(user.uid);
                    if (userData != null) {
                      if (userData.type == 'aluno') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AlunoDashboard(user: userData)),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ProfessorDashboard(user: userData)),
                        );
                      }
                    }
                  }
                } catch (e) {
                  print('Erro ao fazer login: $e');
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: const Text('Entrar com o Google'),
            ),
          ],
        ),
      ),
    );
  }
}
