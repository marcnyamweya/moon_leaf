import 'package:flutter/material.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Updates')),
      body: const Center(
        child: Text('You are on the Updates screen'),
      ),
    );
  }
}


