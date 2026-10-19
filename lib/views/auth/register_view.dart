import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_proj/viewmodel/auth_view_model.dart';
import 'package:supabase_proj/views/auth/login_view.dart';
import 'package:supabase_proj/views/home_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Registrazione')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsetsGeometry.all(16),
              child: Column(
                children: [
                  // textfield per email
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  // text field per password
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await vm.register(
                        emailController.text,
                        passwordController.text,
                      );
                      if (vm.session != null && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeView()),
                        );
                      }
                    },
                    child: const Text('Registrati'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoginView()),
                      );
                    },
                    child: const Text('Hai un account? Loggati'),
                  ),
                ],
              ),
            ),
    );
  }
}
