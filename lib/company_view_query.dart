import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'company_home.dart';

class ViewQueryPage extends StatefulWidget {
  @override
  _ViewQueryPageState createState() => _ViewQueryPageState();
}

class _ViewQueryPageState extends State<ViewQueryPage> {
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
      String categoryUrl = ip! + "/api/comp_view_query";

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

  Future<void> _sendReply(String queryId, String replyText) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String? lid = pref.getString("lid");
      String? ip = pref.getString("url");

      if (lid == null || ip == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error retrieving user details')),
        );
        return;
      }

      String url = "$ip/api/comp_send_query";
      var response = await http.post(
        Uri.parse(url),
        body: {'query_id': queryId, 'reply': replyText, 'lid': lid},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reply sent successfully!')),
        );
        loadMessages(); // Refresh the queries after sending a reply.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send reply')),
        );
      }
    } catch (e) {
      print("Error sending reply: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sending reply')),
      );
    }
  }

  void _showReplyDialog(String queryId) {
    final TextEditingController _replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send Reply'),
          content: TextField(
            controller: _replyController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter your reply here',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String replyText = _replyController.text.trim();
                if (replyText.isNotEmpty) {
                  Navigator.of(context).pop();
                  _sendReply(queryId, replyText);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reply cannot be empty')),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Queries'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CompanyHomeApp()));
          },
        ),
        centerTitle: true,
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
                  final query = messageData[index]['query'];
                  final reply = messageData[index]['reply'];
                  final date = messageData[index]['date'];
                  final queryId = messageData[index]['querires_id'].toString();

                  return Card(
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
                            'Query: $query',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Reply: ${reply.isEmpty ? 'No reply yet' : reply}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Date: $date',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _showReplyDialog(queryId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                            ),
                            child: const Text(
                              'Send Reply',
                              style: TextStyle(fontSize: 16,color: Colors.white),
                            ),
                          ),
                        ],
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
