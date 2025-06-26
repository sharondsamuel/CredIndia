import 'package:flutter/material.dart';
import 'admin_view_feedback.dart';
import 'admin_view_finance_company.dart';
import 'admin_view_users.dart';
import 'company_manage_finance.dart';
import 'company_view_query.dart';
import 'company_view_request.dart';
import 'login.dart';

void main() {
  runApp(const CompanyHomeApp());
}

class CompanyHomeApp extends StatelessWidget {
  const CompanyHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Company Home',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const CompanyHomePage(),
    );
  }
}

class CompanyHomePage extends StatelessWidget {
  const CompanyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Home'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore the sections below to manage your tasks:',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    label: 'Home',
                    icon: Icons.home,
                    color: Colors.blue,
                    destination: const CompanyHomePage(),
                  ),
                  _buildMenuCard(
                    context,
                    label: 'Finances',
                    icon: Icons.money,
                    color: Colors.green,
                    destination: ManageFinanceApp(),
                  ),
                  _buildMenuCard(
                    context,
                    label: 'View Query',
                    icon: Icons.account_balance,
                    color: Colors.orange,
                    destination: ViewQueryPage(),
                  ),
                  _buildMenuCard(
                    context,
                    label: 'View Request',
                    icon: Icons.request_page,
                    color: Colors.purple,
                    destination: CompanyViewRequest(),
                  ),
                  _buildMenuCard(
                    context,
                    label: 'Logout',
                    icon: Icons.logout,
                    color: Colors.red,
                    destination: login(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required String label,
        required IconData icon,
        required Color color,
        required Widget destination}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
