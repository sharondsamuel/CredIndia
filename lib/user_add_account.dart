import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttercode/userhome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AccountDetailsApp());
}

class AccountDetailsApp extends StatelessWidget {
  const AccountDetailsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Details',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AccountDetailsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AccountDetailsPage extends StatefulWidget {
  const AccountDetailsPage({super.key});

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  List<Map<String, dynamic>> messageData = [];
  String? ip;
  String? status;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String? lid = pref.getString("lid");
      ip = pref.getString("url");

      if (ip == null || lid == null) {
        throw Exception("Missing configuration values.");
      }

      String categoryUrl = "$ip/api/view_account";

      var response = await http.post(
        Uri.parse(categoryUrl),
        body: {'lid': lid},
      );

      var jsonData = json.decode(response.body);
      status = jsonData['status'];

      if (status == "true") {
        setState(() {
          messageData = List<Map<String, dynamic>>.from(jsonData['data']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load account details')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading account details')),
      );
    }
  }

  Future<void> _submitDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final sh = await SharedPreferences.getInstance();
        String? lid = sh.getString("lid");
        String? url = sh.getString("url");

        if (lid == null || url == null) {
          throw Exception("Missing configuration values.");
        }

        Map<String, dynamic> postData = {
          'acc_no': _accountNumberController.text,
          'ifsc': _ifscController.text,
          'bank_name': _bankNameController.text,
          'lid': lid,
        };

        var response = await http.post(
          Uri.parse("$url/api/add_account"),
          body: postData,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account details submitted successfully!')),
          );
          await loadMessages();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit account details')),
          );
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error submitting account details')),
        );
      }
    }
  }

  Future<void> deleteFinance(String financeId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String? url = pref.getString("url");

      if (url == null) {
        throw Exception("Missing configuration values.");
      }

      String deleteUrl = "$url/api/delete_account";

      var response = await http.post(Uri.parse(deleteUrl), body: {'acc_id': financeId});

      if (response.statusCode == 200) {
        setState(() {
          messageData.removeWhere((item) => item['account_details_id'].toString() == financeId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account entry deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete account entry')),
        );
      }
    } catch (e) {
      print("Error deleting finance: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting account entry')),
      );
    }
  }

  void _showOptions(String financeId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              deleteFinance(financeId);
            },
          ),
          ListTile(
            leading: const Icon(Icons.close, color: Colors.blue),
            title: const Text('Close'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Account Details'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserHomeApp()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Account Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Account Number Field
              TextFormField(
                controller: _accountNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your account number';
                  }
                  if (value.length < 9 || value.length > 18) {
                    return 'Account number must be between 9-18 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // IFSC Code Field
              TextFormField(
                controller: _ifscController,
                decoration: InputDecoration(
                  labelText: 'IFSC Code',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the IFSC code';
                  }
                  if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value)) {
                    return 'Enter a valid IFSC code (e.g., ABCD0123456)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Bank Name Field
              TextFormField(
                controller: _bankNameController,
                decoration: InputDecoration(
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the bank name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              // Submit Button
              ElevatedButton(
                onPressed: _submitDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: messageData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = messageData[index];
                    final bankName = data['bank_name'] ?? '';
                    final accNo = data['acc_no'] ?? '';
                    final ifsc = data['ifsc'] ?? '';
                    final accountId = data['account_details_id'].toString();

                    return GestureDetector(
                      onTap: () => _showOptions(accountId),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bank Name: $bankName', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('IFSC: $ifsc', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Account Number: $accNo', style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
