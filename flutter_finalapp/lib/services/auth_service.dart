import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função para registrar um novo usuário com email e senha
  Future<User?> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String type,
    required List<String> disciplines,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Salvar dados no Firestore (incluindo senha)
      await saveUserDataToFirestore(
        userCredential.user!.uid,
        name,
        email,
        type,
        password,
        disciplines,
      );

      return userCredential.user;
    } catch (e) {
      print("Erro ao registrar: $e");
      return null;
    }
  }

  // Função para login com email e senha
  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Erro ao fazer login: $e");
      return null;
    }
  }

  // Função para logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Recuperar dados do Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
      return null;
    }
  }

  // Salvar dados no Firestore
  Future<bool> saveUserDataToFirestore(
      String uid,
      String name,
      String email,
      String type,
      String password,
      List<String> disciplines,
      ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'type': type,
        'password': password, // Armazenando senha no Firestore (não recomendado em produção)
        'disciplines': disciplines,
      });
      return true;
    } catch (e) {
      print("Erro ao salvar dados no Firestore: $e");
      return false;
    }
  }
}
