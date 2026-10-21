import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_proj/viewmodel/auth_view_model.dart';
import 'package:supabase_proj/views/add_book_view.dart';
import 'package:supabase_proj/views/auth/login_view.dart';
import 'package:supabase_proj/views/widgets/bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Supabase App'),
        actions: [
          IconButton(
            onPressed: () async {
              await vm.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginView()),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBookView()),
            );
          },
          child: Text('Aggiungi un libro'),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
