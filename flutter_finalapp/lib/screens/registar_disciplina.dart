import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class RegistarDisciplinaScreen extends StatefulWidget {
  final AppUser user;
  const RegistarDisciplinaScreen({super.key, required this.user});

  @override
  State<RegistarDisciplinaScreen> createState() => _RegistarDisciplinaScreenState();
}

class _RegistarDisciplinaScreenState extends State<RegistarDisciplinaScreen> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String descricao = '';
  bool isLoading = false;

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final col = FirebaseFirestore.instance.collection('disciplinas');
      await col.add({
        'usuarioId': widget.user.uid,
        'usuarioTipo': widget.user.type,
        'nome': nome.trim(),
        'descricao': descricao.trim(),
        'dataCriacao': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disciplina registada!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registar Disciplina')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome da disciplina'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
                onChanged: (v) => nome = v,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                onChanged: (v) => descricao = v,
              ),
              const SizedBox(height: 32),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
