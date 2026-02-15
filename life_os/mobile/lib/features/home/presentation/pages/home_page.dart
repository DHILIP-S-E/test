import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.push('/finance'),
              child: const Text('Go to Finance Module'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/tasks'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Go to Tasks Module'),
            ),
          ],
        ),
      ),
    );
  }
}
