import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class AlunoDashboard extends StatelessWidget {
  final AppUser user;

  const AlunoDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard do Aluno')),
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
