import 'package:flutter/material.dart';

class LoadingScreen  extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      height: 400,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}