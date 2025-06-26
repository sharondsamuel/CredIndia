import 'package:flutter/material.dart';
import 'package:fluttercode/userhome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'company_home.dart';
import 'company_view_account_details.dart';

class CompanyViewRequest extends StatefulWidget {
  @override
  _CompanyViewRequestPageState createState() => _CompanyViewRequestPageState();
}

class _CompanyViewRequestPageState extends State<CompanyViewRequest> {
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
      String categoryUrl = "$ip/api/company_view_request";

      var data = await http.post(Uri.parse(categoryUrl), body: {'lid': lid});

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

  void showOptionsDialog(Map<String, dynamic> requestData) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Accept'),
                onTap: () {
                  Navigator.pop(context);
                  handleAccept(requestData['request_id'].toString());
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.red),
                title: Text('Reject'),
                onTap: () {
                  Navigator.pop(context);
                  handleReject(requestData['request_id'].toString());
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle, color: Colors.blue),
                title: Text('View Account Details'),
                onTap: () {
                  Navigator.pop(context);
                  handleViewAccountDetails(requestData['user_id'].toString());
                },
              ),
              if (requestData['status'] == "Accepted")
                ListTile(
                  leading: Icon(Icons.update, color: Colors.orange),
                  title: Text('Update Status'),
                  onTap: () {
                    Navigator.pop(context);
                    handleUpdateStatus(requestData['request_id'].toString());
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> handleAccept(String requestId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      ip = pref.getString("url") ?? "";
      String categoryUrl = "$ip/api/company_accept_request";

      var response = await http.post(Uri.parse(categoryUrl), body: {'request_id': requestId});
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == "true") {
        loadMessages(); // Refresh the list after accepting.
      } else {
        print("Error: ${jsonData['message']}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> handleReject(String requestId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      ip = pref.getString("url") ?? "";
      String categoryUrl = "$ip/api/company_reject_request";

      var response = await http.post(Uri.parse(categoryUrl), body: {'request_id': requestId});
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == "true") {
        loadMessages(); // Refresh the list after rejecting.
      } else {
        print("Error: ${jsonData['message']}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> handleViewAccountDetails(String userId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => company_view_account(uid: userId),
      ),
    );
  }


  Future<void> handleUpdateStatus(String requestId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      ip = pref.getString("url") ?? "";
      String categoryUrl = "$ip/api/company_update_status";

      var response = await http.post(Uri.parse(categoryUrl), body: {'request_id': requestId});
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == "true") {
        loadMessages(); // Refresh the list after updating status.
      } else {
        print("Error: ${jsonData['message']}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance'),
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
                  final requestData = messageData[index];
                  final fname = requestData['fname'];
                  final finance = requestData['finance'];
                  final reason = requestData['reason'];
                  final status = requestData['status'];
                  final date = requestData['req_date'];

                  return GestureDetector(
                    onTap: () => showOptionsDialog(requestData),
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
                            SizedBox(height: 8),
                            Text('Name: $fname', style: TextStyle(fontSize: 16)),
                            Text('Finance: $finance', style: TextStyle(fontSize: 16)),
                            Text('Reason: $reason', style: TextStyle(fontSize: 16)),
                            Text('Status: $status', style: TextStyle(fontSize: 16)),
                            Text('Request Date: $date', style: TextStyle(fontSize: 16)),
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
