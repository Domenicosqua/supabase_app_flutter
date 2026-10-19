import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_proj/core/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  // creiamo l'istanza del AuthService per poterlo chiamare
  final AuthService _authService = AuthService();

  bool isLoading = false; // flag per tenere traccia di una funzione asincrona, ci permette di fornire un feedback visivo all'utente
  // questa variabile, che può essere null, ci serve per le info relative alla sessione, token d'accesso ecc. Se non è null c'è un utente loggato
  Session? session;

  // ci serve per conoscere lo stato della sessione dell'utente, esempio se già loggato alla riapertura dell'app
  AuthViewModel() {
    session = _authService.currentSession;
  }

  // metodo per la login
  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.signIn(email, password);
      session = response.session;
    } catch (e) {
      print('errore login $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // metodo per la registrazione
  Future<void> register(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.signUp(email, password);
      session = response.session;
    } catch (e) {
      print('errore: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // metodo per logout
  Future<void> logout() async {
    await _authService.signOut();
    session = null;

    notifyListeners();
  }
}
