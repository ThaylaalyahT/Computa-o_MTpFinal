import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class ProfessorDashboard extends StatelessWidget {
  final AppUser user;

  const ProfessorDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard do Professor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bem-vindo, ${user.name}!', style: TextStyle(fontSize: 24)),
            Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
            Text('Tipo: ${user.type}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
