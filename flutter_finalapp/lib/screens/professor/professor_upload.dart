import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalapp/models/user_model.dart';

class RegistarTarefaScreen extends StatefulWidget {
  final String professorId;
  final AppUser user;

  const RegistarTarefaScreen({
    super.key,
    required this.professorId,
    required this.user,
  });

  @override
  State<RegistarTarefaScreen> createState() => _RegistarTarefaScreenState();
}

class _RegistarTarefaScreenState extends State<RegistarTarefaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  String? _disciplinaSelecionada;
  DateTime? _dataSelecionada;

  List<String> _disciplinas = [];

  @override
  void initState() {
    super.initState();
    _carregarDisciplinas();
  }

  Future<void> _carregarDisciplinas() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('disciplinas')
          .where('usuarioId', isEqualTo: widget.user.uid)
          .get();

      final nomes = snapshot.docs.map((doc) => doc['nome'] as String).toList();

      setState(() {
        _disciplinas = nomes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar disciplinas: $e')),
      );
    }
  }

  void _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  void _salvarTarefa() async {
    if (_formKey.currentState!.validate() &&
        _dataSelecionada != null &&
        _disciplinaSelecionada != null) {
      try {
        await FirebaseFirestore.instance.collection('tarefas').add({
          'titulo': _tituloController.text.trim(),
          'descricao': _descricaoController.text.trim(),
          'disciplina': _disciplinaSelecionada,
          'data': Timestamp.fromDate(_dataSelecionada!),
          'professorId': widget.professorId,
          'entregue': false,
          'criadoEm': Timestamp.now(),
        });

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarefa registada com sucesso!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar tarefa: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Preencha todos os campos e selecione uma data.')),
      );
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registar Nova Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Disciplina'),
                value: _disciplinaSelecionada,
                items: _disciplinas
                    .map((disciplina) => DropdownMenuItem<String>(
                  value: disciplina,
                  child: Text(disciplina),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _disciplinaSelecionada = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Selecione uma disciplina' : null,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selecionarData,
                child: Text(
                  _dataSelecionada == null
                      ? 'Selecionar Data de Entrega'
                      : 'Data: ${_dataSelecionada!.toLocal().toString().split(' ')[0]}',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarTarefa,
                child: const Text('Salvar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
