import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String email = '';
  String password = '';
  bool isLoading = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final user = await _authService.loginWithEmail(email: email, password: password);

    setState(() => isLoading = false);

    if (user != null) {
      final userData = await _authService.getUserData(user.uid);
      if (userData != null) {
        final userType = userData['type'];
        final appUser = AppUser(
          uid: user.uid,
          name: userData['name'],
          email: userData['email'],
          type: userData['type'],
          disciplines: userData['disciplines'] != null
              ? List<String>.from(userData['disciplines'].map((e) => e.toString()))
              : <String>[],
        );


        if (userType == 'aluno') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AlunoDashboard(user: appUser),
            ),
          );
        } else if (userType == 'professor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfessorDashboard(user: appUser),
            ),
          );
        }
      }
    } else {
      _showMessage('Erro ao fazer login. Tente novamente.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val != null && val.contains('@') ? null : 'Insira um email vÃ¡lido',
                onChanged: (val) => email = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (val) => val != null && val.length >= 6 ? null : 'Senha deve ter pelo menos 6 caracteres',
                onChanged: (val) => password = val,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _login,
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}