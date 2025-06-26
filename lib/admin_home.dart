import 'package:flutter/material.dart';
import 'admin_view_feedback.dart';
import 'admin_view_finance_company.dart';
import 'admin_view_users.dart';
import 'login.dart';

void main() {
  runApp(const adminhome());
}

class adminhome extends StatelessWidget {
  const adminhome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Home',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const adminHomePage(),
    );
  }
}

class adminHomePage extends StatelessWidget {
  const adminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Admin Home',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Navigate through the sections below:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            _buildMenuButton(
              context,
              label: 'Home',
              icon: Icons.home,
              destination: const adminHomePage(),
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              label: 'Users',
              icon: Icons.person,
              destination: admin_view_user(),
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              label: 'View Finance',
              icon: Icons.account_balance,
              destination: admin_view_finance_company(),
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              label: 'Feedback',
              icon: Icons.feedback,
              destination: admin_view_feedback(),
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              label: 'Logout',
              icon: Icons.logout,
              destination: login(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String label, required IconData icon, required Widget destination}) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      icon: Icon(icon, size: 24),
      label: Text(label, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
