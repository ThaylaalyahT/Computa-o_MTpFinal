import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalapp/models/user_model.dart';

class RegistrarTarefaScreen extends StatefulWidget {
  final String professorId;
  final AppUser user;

  const RegistrarTarefaScreen({
    super.key,
    required this.professorId,
    required this.user,
  });

  @override
  State<RegistrarTarefaScreen> createState() => _RegistrarTarefaScreenState();
}

class _RegistrarTarefaScreenState extends State<RegistrarTarefaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime? _dataSelecionada;

  List<String> _disciplinas = [];
  String? _disciplinaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarDisciplinas();
  }

  Future<void> _carregarDisciplinas() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('disciplinas')
          .where('usuarioId', isEqualTo: widget.professorId)
          .get();

      setState(() {
        _disciplinas = snapshot.docs.map((doc) => doc['nome'].toString()).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar disciplinas: $e')),
      );
    }
  }

  void _selecionarData() async {
    final DateTime? picked = await showDatePicker(
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
          'data': Timestamp.fromDate(_dataSelecionada!),
          'professorId': widget.professorId,
          'disciplina': _disciplinaSelecionada,
          'entregue': false,
          'criadoEm': Timestamp.now(),
        });

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarefa registrada com sucesso!')),
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
            content: Text('Por favor, preencha todos os campos e selecione a data.')),
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
      appBar: AppBar(title: const Text('Registrar Nova Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Disciplina'),
                  value: _disciplinaSelecionada,
                  items: _disciplinas.map((disciplina) {
                    return DropdownMenuItem<String>(
                      value: disciplina,
                      child: Text(disciplina),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    setState(() {
                      _disciplinaSelecionada = valor;
                    });
                  },
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Selecione uma disciplina' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _selecionarData,
                  child: Text(
                    _dataSelecionada == null
                        ? 'Selecionar Data de Entrega'
                        : 'Data: ${_dataSelecionada!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _salvarTarefa,
                  child: const Text('Salvar Tarefa'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
