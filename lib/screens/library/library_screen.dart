import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:moon_leaf/screens/browse/browse_screen.dart';

// final _router = GoRouter(
//   routes: [
//     GoRoute(path: '/browse', builder: (context, state) => const BrowseScreen()),
//     // Add more routes here
//   ],
// );
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body:  Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/browse');
          },
          child: const Text('Library Screen'),
        ),
      ),
    );
  }
}