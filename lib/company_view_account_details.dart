import 'company_home.dart';
import 'user_send_query.dart';
import 'user_view_instructions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_view_finance.dart';

class company_view_account extends StatefulWidget {
  final String uid;

  const company_view_account({Key? key, required this.uid}) : super(key: key);
  @override
  _company_view_accountPageState createState() => _company_view_accountPageState();
}

class _company_view_accountPageState extends State<company_view_account> {
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
      String categoryUrl = ip! + "/api/company_view_account";

      var data = await http.post(Uri.parse(categoryUrl), body: {'lid': widget.uid});

      var jsonData = json.decode(data.body);
      status = jsonData['status'];

      if (status == "true") {
        setState(() {
          messageData = List<Map<String, dynamic>>.from(jsonData['data']);
        });
      } else {
        // Handle error status if needed
      }
    } catch (e) {
      print("Error: $e");
      // Handle any errors that occur during the HTTP request.
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CompanyHomeApp()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messageData.length,
                itemBuilder: (BuildContext context, int index) {
                  final acc_no = messageData[index]['acc_no'];
                  final ifsc = messageData[index]['ifsc'];
                  final bankname = messageData[index]['bankname'];
        

                  return GestureDetector(
                    // onTap: () => _showOptions(financeId,cid),
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
                            Text(
                              'Account Number: $acc_no',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'IFSC: $ifsc',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bank name: $bankname',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                          
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
    );
  }
}
