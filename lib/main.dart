import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_proj/core/supabase_client.dart';
import 'package:supabase_proj/viewmodel/auth_view_model.dart';
import 'package:supabase_proj/viewmodel/book_view_model.dart';
import 'package:supabase_proj/viewmodel/profile_view_model.dart';
import 'package:supabase_proj/views/auth/login_view.dart';
import 'package:supabase_proj/views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientManager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => BookViewModel()),
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, auth, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.lightGreen,
                brightness: Brightness.dark,
              ),
            ),
            home: auth.session != null ? HomeView() : LoginView(),
          );
        },
      ),
    );
  }
}
