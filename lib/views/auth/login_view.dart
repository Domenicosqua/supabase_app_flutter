import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_proj/viewmodel/auth_view_model.dart';
import 'package:supabase_proj/views/auth/register_view.dart';
import 'package:supabase_proj/views/home_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Accedi')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsetsGeometry.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await vm.login(
                        emailController.text,
                        passwordController.text,
                      );
                      if (vm.session != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeView()),
                        );
                      }
                    },
                    child: const Text('data'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterView()),
                      );
                    },
                    child: const Text('Non hai un account? Registrati'),
                  ),
                ],
              ),
            ),
    );
  }
}
