import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'company_home.dart';

class ManageInstructionsPage extends StatefulWidget {
  final String financeId;

  const ManageInstructionsPage({super.key, required this.financeId});

  @override
  State<ManageInstructionsPage> createState() => _ManageInstructionsPageState();
}

class _ManageInstructionsPageState extends State<ManageInstructionsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController instructionController = TextEditingController();
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
      ip = pref.getString("url") ?? "";
      String categoryUrl = "$ip/api/company_view_instructions";

      var response = await http.post(Uri.parse(categoryUrl), body: {
        'finance_id': widget.financeId,
      });

      var jsonData = json.decode(response.body);
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

  Future<void> deleteFinance(String instructions_id) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String url = pref.getString("url") ?? '';
      String deleteUrl = "$url/api/company_delete_instructions";

      var response = await http.post(Uri.parse(deleteUrl), body: {
        'instructions_id': instructions_id,
      });

      if (response.statusCode == 200) {
        setState(() {
          messageData.removeWhere((item) => item['instructions_id'] == instructions_id);
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompanyHomeApp()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Instruction deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete instruction')),
        );
      }
    } catch (e) {
      print("Error deleting instruction: $e");
    }
  }

  Future<void> _submitInstruction() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final sh = await SharedPreferences.getInstance();
        String instruction = instructionController.text;
        String url = sh.getString("url") ?? '';
        String apiUrl = "$url/api/manage_instructions";

        var response = await http.post(Uri.parse(apiUrl), body: {
          'instruction': instruction,
          'finance_id': widget.financeId,
        });

        if (response.statusCode == 200) {
          print("Instruction added successfully");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CompanyHomeApp()),
          );
        } else {
          print("Failed to add instruction. Error code: ${response.statusCode}");
        }
      } catch (e) {
        print("Error submitting instruction: $e");
      }
    }
  }

  void _showOptions(String instructions_id) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              deleteFinance(instructions_id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.close, color: Colors.blue),
            title: const Text('Close'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Instructions'),
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
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add an Instruction',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: instructionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Instruction',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.info_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the instruction';
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
                      onPressed: _submitInstruction,
                      child: const Text(
                        'Save Instruction',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: messageData.length,
                itemBuilder: (context, index) {
                  final instruction = messageData[index]['instructions'];
                  return Card(
                    child: ListTile(
                      title: Text(instruction),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          _showOptions(messageData[index]['instructions_id'].toString());
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
