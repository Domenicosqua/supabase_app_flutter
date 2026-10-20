import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_proj/core/profile_service.dart';
import 'package:supabase_proj/models/user_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final SupabaseClient _client = Supabase.instance.client;

  // recupero profilo utente
  UserProfile? profile;
  bool isLoading = false;

  //* metodo per recuperare i dati
  Future<void> loadUserProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      profile = await _profileService.fetchUserProfile();
    } catch (e) {
      print('errore: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  //* creazione nuovo profilo utente dopo la registrazione
  Future<void> createUserProfile(String username, DateTime birthdate) async {
    final id = _client.auth.currentUser?.id;
    if (id == null) return;

    final newProfile = UserProfile(
      id: id,
      username: username,
      birthdate: birthdate,
      avatarUrl: null,
    );

    try {
      await _profileService.createUserProfile(newProfile);
      profile = newProfile;
    } catch (e) {
      print('errore: $e');
    }

    notifyListeners();
  }

  //* aggiornamento profilo esistente
  Future<void> updateUserProfile(UserProfile updateUserProfile) async {
    try {
      await _profileService.updateUserProfile(updateUserProfile);
      profile = updateUserProfile;
    } catch (e) {
      print('errore: $e');
    }

    notifyListeners();
  }
}
