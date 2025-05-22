import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class ProfessorDashboard extends StatefulWidget {
  final AppUser user;
  const ProfessorDashboard({super.key, required this.user});

  @override
  State<ProfessorDashboard> createState() => _ProfessorDashboardState();
}

class _ProfessorDashboardState extends State<ProfessorDashboard> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String novaNota = '';

  Future<void> _logout(BuildContext ctx) async {
    await _auth.logout();
    Navigator.pushReplacementNamed(ctx, '/login');
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
          TextButton(
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
                    'data': Timestamp.now(),
                  });
                  Navigator.pop(context);
                } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Text('Olá docente ${widget.user.name}!', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),

            // Cards: Notas e Calendário
            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Notas',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
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
                const SizedBox(width: 10),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: DateTime.now(),
                      calendarFormat: CalendarFormat.week,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // título do mês
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), // dias da semana (Seg, Ter, ...)
                        weekendStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      calendarStyle: const CalendarStyle(
                        defaultTextStyle: TextStyle(fontSize: 12),     // dias normais
                        weekendTextStyle: TextStyle(fontSize: 12),     // fim de semana
                        outsideTextStyle: TextStyle(fontSize: 10, color: Colors.grey), // dias fora do mês
                        selectedTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // dia selecionado
                        todayTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      onDaySelected: (selectedDay, focusedDay) {},
                      selectedDayPredicate: (day) => isSameDay(day, DateTime.now()),
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
                        arguments: widget.user,
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

            // Lista de tarefas
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tarefas')
                    .where('professorId', isEqualTo: widget.user.uid)
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
                      final tarefa = docs[index].data()! as Map<String, dynamic>;
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
                Navigator.pushNamed(context, '/disciplinas', arguments: widget.user);
              },
            ),
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () {
                Navigator.pushNamed(context, '/professor_upload', arguments: widget.user);
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Ação para configurações
              },
            ),
          ],
        ),
      ),
    );
  }
}
