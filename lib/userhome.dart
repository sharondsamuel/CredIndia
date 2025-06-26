import 'user_add_account.dart';
import 'user_send_feedback.dart';
import 'user_send_query.dart';
import 'user_view_finances.dart';
import 'user_view_request.dart';
import 'package:flutter/material.dart';
import 'admin_view_feedback.dart';
import 'admin_view_finance_company.dart';
import 'admin_view_users.dart';
import 'login.dart';

void main() {
  runApp(const UserHomeApp());
}

class UserHomeApp extends StatelessWidget {
  const UserHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Home with Drawer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserHomePage(),
    );
  }
}

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Home'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/finance1.jpg'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'User Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
            _buildDrawerItem(
              context,
              label: 'Home',
              icon: Icons.home,
              destination: const UserHomePage(),
            ),
            _buildDrawerItem(
              context,
              label: 'Account Details',
              icon: Icons.person,
              destination: AccountDetailsApp(),
            ),
            _buildDrawerItem(
              context,
              label: 'View Finance',
              icon: Icons.account_balance,
              destination: user_view_finance(),
            ),
            _buildDrawerItem(
              context,
              label: 'View Request',
              icon: Icons.request_page,
              destination: user_view_request(),
            ),
            _buildDrawerItem(
              context,
              label: 'Send Feedback',
              icon: Icons.feedback,
              destination: FeedbackPage(),
            ),
            _buildDrawerItem(
              context,
              label: 'Logout',
              icon: Icons.logout,
              destination: login(),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/finance1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Welcome to User Home',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Use the drawer to navigate to different sections.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required String label, required IconData icon, required Widget destination}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label, style: const TextStyle(fontSize: 18)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}
