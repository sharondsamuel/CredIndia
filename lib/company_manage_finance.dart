import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// import 'add_instruction_page.dart'; // Create this page for adding instructions
import 'company_home.dart';
import 'company_manage_instructions.dart';

void main() {
  runApp(const ManageFinanceApp());
}

class ManageFinanceApp extends StatelessWidget {
  const ManageFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage Finance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ManageFinancePage(),
    );
  }
}

class ManageFinancePage extends StatefulWidget {
  const ManageFinancePage({super.key});

  @override
  State<ManageFinancePage> createState() => _ManageFinancePageState();
}

class _ManageFinancePageState extends State<ManageFinancePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController financeNameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
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
      String lid = pref.getString("lid").toString();

      ip = pref.getString("url") ?? "";
      String categoryUrl = ip! + "/api/company_view_finance";

      var data = await http.post(Uri.parse(categoryUrl), body: {'lid': lid});

      var jsonData = json.decode(data.body);
      status = jsonData['status'];

      if (status == "true") {
        setState(() {
          messageData = List<Map<String, dynamic>>.from(jsonData['data']);
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> deleteFinance(String financeId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String url = pref.getString("url") ?? '';
      String deleteUrl = "$url/api/company_delete_finance";

      var response = await http.post(Uri.parse(deleteUrl), body: {'finance_id': financeId});

      if (response.statusCode == 200) {
        setState(() {
          messageData.removeWhere((item) => item['finance_id'] == financeId);
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>CompanyHomeApp(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(content: Text('Finance entry deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete finance entry')),
        );
      }
    } catch (e) {
      print("Error deleting finance: $e");
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
            leading: const Icon(Icons.add, color: Colors.blue),
            title: const Text('Add Instruction'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageInstructionsPage(financeId: financeId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  Future<void> _submitForm() async {
    final sh = await SharedPreferences.getInstance();
    String name = financeNameController.text;
    String details = detailsController.text;

    String lid = sh.getString("lid").toString();
    String url = sh.getString("url") ?? '';
    Map<String, dynamic> postData = {
      'finance': name,
      'details': details,
      'lid':lid


    };

    String jsonBody = jsonEncode(postData);

    var response = await http.post(
      Uri.parse(url+ "/api/manage_finance"),

      body: postData,
    );

    if (response.statusCode == 200) {
      print("Data sent successfully");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompanyHomeApp()),
      );
    } else {
      print("Failed to send data. Error code: ${response.statusCode}");
      // Handle error
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Finance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CompanyHomeApp()));
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Finance Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: financeNameController,
                decoration: InputDecoration(
                  labelText: 'Finance Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.account_balance_wallet),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the finance name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: detailsController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    _submitForm();
                  },
                  child: const Text(
                    'Add Finance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: messageData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final finance = messageData[index]['finance'];
                    final details = messageData[index]['details'];
                    final date = messageData[index]['date'];
                    final financeId = messageData[index]['finance_id'].toString();

                    return GestureDetector(
                      onTap: () => _showOptions(financeId),
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
                              Text('Finance: $finance', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Details: $details', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Date: $date', style: const TextStyle(fontSize: 16)),
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
