// tarefas_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../models/task_model.dart';

class TarefasPendentesScreen extends StatelessWidget {
  const TarefasPendentesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tarefas')
            .orderBy('data') // opcional, para mostrar em ordem crescente
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar tarefas'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(child: Text('Nenhuma tarefa pendente.'));
          }

          final tarefas = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Task.fromMap(data, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              final tarefa = tarefas[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(tarefa.titulo),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tarefa.descricao),
                      SizedBox(height: 4),
                      Text(
                        'Data: ${DateFormat('dd/MM/yyyy').format(tarefa.dataConvertida)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: null, // Lógica de entrega ainda não implementada
                    child: Text('Entregar'),
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
