import 'package:flutter/material.dart';

class NovelScreen extends StatelessWidget {
  final String novelId;

  const NovelScreen({super.key, required this.novelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novel')),
      body: Center(
        child: Text('You are on the Novel screen (id: $novelId)'),
      ),
    );
  }
}


