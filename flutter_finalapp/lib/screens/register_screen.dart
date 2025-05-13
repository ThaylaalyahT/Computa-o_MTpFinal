import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String name = '';
  String email = '';
  String password = '';
  String type = 'aluno'; // Tipo padrão

  bool isLoading = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // Registrar e salvar dados no Firestore
      final user = await _authService.registerWithEmail(
        name: name,
        email: email,
        password: password,
        type: type,
      );

      setState(() => isLoading = false);

      if (user != null) {
        _showMessage('Registro bem-sucedido!');
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showMessage('Erro ao registrar. Tente novamente.');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showMessage('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Insira seu nome' : null,
                onChanged: (val) => name = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                val != null && val.contains('@') ? null : 'Email inválido',
                onChanged: (val) => email = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (val) => val != null && val.length >= 6
                    ? null
                    : 'Senha deve ter pelo menos 6 caracteres',
                onChanged: (val) => password = val,
              ),
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'aluno', child: Text('Aluno')),
                  DropdownMenuItem(value: 'professor', child: Text('Professor')),
                ],
                onChanged: (val) => setState(() => type = val!),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _register,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
