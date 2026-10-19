import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  //* metodo per registrare un nuovo utente
  Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  //* metodo login utente
  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  //* metodo logOut utente
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  //* questo metodo ci permette di avere i dati dell'utente che al momento è in sessione
  Session? get currentSession => _client.auth.currentSession;
}
