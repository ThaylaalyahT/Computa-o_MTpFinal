import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_finalapp/models/user_model.dart';
import 'package:flutter_finalapp/models/task_model.dart';
import 'package:flutter_finalapp/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AlunoDashboard extends StatefulWidget {
  final AppUser user;
  const AlunoDashboard({super.key, required this.user});

  @override
  State<AlunoDashboard> createState() => _AlunoDashboardState();
}

class _AlunoDashboardState extends State<AlunoDashboard> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String novaNota = '';

  Future<void> _logout(BuildContext ctx) async {
    await _auth.logout();
    Navigator.pushReplacementNamed(ctx, '/login');
  }

  Future<List<Task>> _buscarTarefasPendentes() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tarefas')
        .where('entregue', isEqualTo: false)
        .orderBy('data')
        .get();

    return snapshot.docs.map((doc) => Task.fromMap(doc.data(), doc.id)).toList();
  }

  Future<String> _buscarFraseApi() async {
    final url = Uri.parse('https://zenquotes.io/api/random');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          final frase = data[0]['q'] ?? '';
          final autor = data[0]['a'] ?? '';
          if (frase.isNotEmpty && autor.isNotEmpty) {
            return '$frase — $autor';
          }
        }
      }
    } catch (e) {
      print('Erro ao buscar frase motivadora: $e');
    }
    return 'Seja sua melhor versão todos os dias.';
  }


  void _adicionarNota() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova nota'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Escreva a sua nota aqui...'),
            validator: (value) =>
            value == null || value.trim().isEmpty ? 'Nota não pode ser vazia' : null,
            onChanged: (value) => novaNota = value.trim(),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  await FirebaseFirestore.instance.collection('notas').add({
                    'uid': widget.user.uid,
                    'conteudo': novaNota,
                    'data': Timestamp.now(), // salva a data da nota
                  });
                  Navigator.pop(context);
                } catch (e) {
                  // Em caso de erro, pode mostrar uma mensagem para o usuário
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao salvar a nota: $e')),
                  );
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
  Future<List<Map<String, dynamic>>> _buscarNotasDoUsuario(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('notas')
        .where('uid', isEqualTo: uid)
        .orderBy('data', descending: true)
        .get();

    return snapshot.docs.map((doc) => {
      'id': doc.id,
      'conteudo': doc['conteudo'],
      'data': (doc['data'] as Timestamp).toDate(),
    }).toList();
  }

  void _mostrarNotasDoUsuario() async {
    final notas = await _buscarNotasDoUsuario(widget.user.uid);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Suas notas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...notas.map((nota) {
              final dataFormatada = DateFormat('dd/MM/yyyy – HH:mm').format(nota['data']);
              return ListTile(
                title: Text(nota['conteudo']),
                subtitle: Text(dataFormatada),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('notas').doc(nota['id']).delete();
                    Navigator.pop(context);
                    _mostrarNotasDoUsuario(); // recarrega após deletar
                  },
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard do Aluno'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Olá ${widget.user.name}!', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                children: [
                  // NOTAS
                  Expanded(
                    child: GestureDetector(
                      onTap: _mostrarNotasDoUsuario,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Notas',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: _adicionarNota,
                                  ),
                                ],
                              ),
                              const Text("Adicione notas para lembrar eventos ou tarefas."),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  // FRASE MOTIVADORA DA API
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Frase motivadora',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            FutureBuilder<String>(
                              future: _buscarFraseApi(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return const Text('Erro ao buscar frase.');
                                }
                                return Text(
                                  snapshot.data ?? '',
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Próximas tarefas', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Task>>(
                future: _buscarTarefasPendentes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhuma tarefa disponível.'));
                  }

                  final tarefas = snapshot.data!;

                  return ListView.separated(
                    itemCount: tarefas.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (ctx, index) {
                      final tarefa = tarefas[index];
                      final dataFormatada =
                      DateFormat('dd/MM/yyyy').format(tarefa.dataConvertida);

                      return ListTile(
                        title: Text(tarefa.titulo),
                        subtitle: Text('Entrega até: $dataFormatada'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.book),
              onPressed: () {
                Navigator.pushNamed(context, '/disciplinas', arguments: widget.user);
              },
            ),
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () {
                Navigator.pushNamed(context, '/aluno_upload', arguments: widget.user);
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
