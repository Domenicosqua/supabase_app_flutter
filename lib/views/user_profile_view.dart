import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_proj/models/user_profile.dart';
import 'package:supabase_proj/viewmodel/profile_view_model.dart';
import 'package:supabase_proj/views/widgets/bottom_nav_bar.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  DateTime? _selectedDate;
  File? _selectedFile;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileVM.loadUserProfile().then((_) {
        final profile = profileVM.profile;
        if (profile != null) {
          _usernameController.text = profile.username;
          _selectedDate = profile.birthdate;
          setState(() {});
        }
      });
    });
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<ProfileViewModel>(context);
    final profile = profileVM.profile;
    return Scaffold(
      appBar: AppBar(title: Text('Profilo Utente')),
      body: profileVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: pickImageFromGallery,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedFile != null
                              ? FileImage(_selectedFile!)
                              : profile?.avatarUrl != null
                              ? NetworkImage(profile!.avatarUrl!)
                              : AssetImage('assets/placeholder.png')
                                    as ImageProvider,
                          child: profile?.avatarUrl == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Inserisci un username';
                        }
                        return null;
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('data di nascita'),
                      subtitle: Text(
                        _selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                            : 'seleziona una data',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final now = DateTime.now();
                        final pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(now.year, now.month, now.day),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _selectedDate != null) {
                          final username = _usernameController.text.trim();
                          if (profile == null) {
                            // crea profilo
                            await profileVM.createUserProfile(
                              username,
                              _selectedDate!,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profilo creato con successo'),
                              ),
                            );
                          } else {
                            final updated = UserProfile(
                              id: profile.id,
                              username: username,
                              birthdate: _selectedDate!,
                              avatarUrl: profile.avatarUrl,
                            );
                            await profileVM.updateUserProfile(updated);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profilo aggiornato'),
                              ),
                            );
                          }
                        }
                      },
                      label: Text('Salva'),
                      icon: Icon(Icons.save),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
