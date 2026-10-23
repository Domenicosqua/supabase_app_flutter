import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_proj/models/book_model.dart';
import 'package:supabase_proj/viewmodel/auth_view_model.dart';
import 'package:supabase_proj/viewmodel/book_view_model.dart';
import 'package:supabase_proj/views/add_book_view.dart';
import 'package:supabase_proj/views/auth/login_view.dart';
import 'package:supabase_proj/views/book_detail_view.dart';
import 'package:supabase_proj/views/widgets/bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bookVM = Provider.of<BookViewModel>(context);
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
      body: bookVM.books.isEmpty
          ? Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddBookView()),
                  );
                },
                child: Text('Aggiungi un libro'),
              ),
            )
          : ListView.builder(
              itemCount: bookVM.books.length,
              itemBuilder: (context, index) {
                final book = bookVM.books[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(book.title),
                    subtitle: Text(book.author),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailView(book: book),
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
