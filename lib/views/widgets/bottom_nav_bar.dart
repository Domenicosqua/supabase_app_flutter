import 'package:flutter/material.dart';
import 'package:supabase_proj/views/home_view.dart';
import 'package:supabase_proj/views/user_profile_view.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomeView();
        break;
      case 1:
        destination = const UserProfileView();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => _onTap(context, 0),
            icon: const Icon(Icons.home),
            color: currentIndex == 0 ? Colors.greenAccent : Colors.white,
          ),
          IconButton(
            onPressed: () => _onTap(context, 1),
            icon: Icon(Icons.person),
            color: currentIndex == 1 ? Colors.greenAccent : Colors.white,
          ),
        ],
      ),
    );
  }
}
