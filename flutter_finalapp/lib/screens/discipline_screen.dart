import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class DisciplineScreen extends StatelessWidget {
  final AppUser user;

  const DisciplineScreen({super.key, required this.user});

  Stream<QuerySnapshot> get _disciplinasStream {
    return FirebaseFirestore.instance
        .collection('disciplinas')
        .where('usuarioId', isEqualTo: user.uid)
        .orderBy('dataCriacao', descending: true)
        .snapshots();
  }

  Future<void> _removerDisciplina(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance.collection('disciplinas').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disciplina removida com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disciplinas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'adicionar') {
                Navigator.pushNamed(context, '/registrar_disciplina', arguments: user);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'adicionar', child: Text('Registrar nova disciplina')),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _disciplinasStream,
        builder: (ctx, snap) {
          if (snap.hasError) return const Center(child: Text('Erro ao carregar.'));
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('Nenhuma disciplina registada.'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (ctx, i) {
              final d = docs[i];
              final data = d.data()! as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(data['nome'] ?? ''),
                  subtitle: data.containsKey('descricao') ? Text(data['descricao']) : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removerDisciplina(context, d.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
