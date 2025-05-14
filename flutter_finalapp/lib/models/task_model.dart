import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String titulo;
  final String descricao;
  final Timestamp data; // Timestamp do Firestore
  late final DateTime dataConvertida; // Convertido para DateTime

  Task({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
  }) {
    // Conversão de Timestamp para DateTime
    dataConvertida = data.toDate();
  }

  // Método seguro para converter dados do Firestore em uma Task
  factory Task.fromMap(Map<String, dynamic> data, String id) {
    final rawData = data['data'];

    // Verificação de tipo e existência do campo 'data'
    if (rawData == null || rawData is! Timestamp) {
      throw Exception("Campo 'data' ausente ou inválido na tarefa com id: $id");
    }

    return Task(
      id: id,
      titulo: data['titulo'] ?? '',
      descricao: data['descricao'] ?? '',
      data: rawData,
    );
  }

  // Método opcional para conversão reversa (útil para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'data': data,
    };
  }
}
