import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class ProfessorDashboard extends StatelessWidget {
  final AppUser user;
  final AuthService _auth = AuthService();

  ProfessorDashboard({super.key, required this.user});

  Future<void> _logout(BuildContext ctx) async {
    await _auth.logout();
    Navigator.pushReplacementNamed(ctx, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(a
          title: const Text('Dashboard do Professor'),
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
    Text('Olá ${user.name}!', style: const TextStyle(fontSize: 20)),
    const SizedBox(height: 20),
    Row(
    children: const [
    Expanded(
    child: Card(
    child: Padding(
    padding: EdgeInsets.all(12),
    child: Text('Sticky Notes'),
    ),
    ),
    ),
    SizedBox(width: 10),
    Expanded(
    child: Card(
    child: Padding(
    padding: EdgeInsets.all(12),
    child: Text('Calendário'),
    ),
    ),
    ),
    ],
    ),
    const SizedBox(height: 20),

    // Título + Botão de opções
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    const Text(
    'Tarefas recebidas',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    PopupMenuButton<String>(
    onSelected: (value) {
    if (value == 'nova_tarefa') {
    Navigator.pushNamed(
    context,
    '/registrar_tarefa',
    arguments: user,
    );
    }
    },
    itemBuilder: (context) => const [
    PopupMenuItem(
    value: 'nova_tarefa',
    child: Text('Registrar nova tarefa'),
    ),
    ],
    ),
    ],
    ),
    const SizedBox(height: 10),

    // Tarefas criadas (notificações)
    Expanded(
    child: StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('tarefas')
        .where('professorId', isEqualTo: user.uid)
        .orderBy('criadoEm', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
    }

    final docs = snapshot.data?.docs ?? [];

    if (docs.isEmpty) {
    return const Center(child: Text('Nenhuma tarefa atribuída ainda.'));
    }

    return ListView.builder(
    itemCount: docs.length,
    itemBuilder: (context, index) {
    final tarefa = docs[index].data() as Map<String, dynamic>;
    return Card(
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: ListTile(
    leading: const Icon(Icons.assignment_outlined),
    title: Text(tarefa['titulo'] ?? ''),
    subtitle: Text(tarefa['descricao'] ?? ''),
    trailing: Text(
    tarefa['data'] != null
    ? (tarefa['data'] as Timestamp)
        .toDate()
        .toLocal()
        .toString()
        .split(' ')[0]
        : '',
    ),
    ),
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
    Navigator.pushNamed(context, '/disciplinas', arguments: user);
    },
    ),
    IconButton(
    icon: const Icon(Icons.upload_file),
    onPressed: () {
    Navigator.pushNamed(context, '/professor_upload', arguments: user);
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
