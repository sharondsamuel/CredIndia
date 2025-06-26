import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttercode/userhome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SendQueryPage extends StatefulWidget {
  final String Cid;

  const SendQueryPage({super.key, required this.Cid});
  @override
  _SendQueryPageState createState() => _SendQueryPageState();
}

class _SendQueryPageState extends State<SendQueryPage> {
  final TextEditingController _queryController = TextEditingController();
  bool _isSubmitting = false;
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
      String categoryUrl = ip! + "/api/user_view_query";

      var data = await http.post(Uri.parse(categoryUrl), body: {'lid': lid,'cid':widget.Cid});

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


  Future<void> _submitQuery() async {
    String query = _queryController.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your query')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? lid = prefs.getString("lid");
      String? ip = prefs.getString("url");

      if (lid == null || ip == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error retrieving user details')),
        );
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      String url = "$ip/api/send_query";
      var response = await http.post(
        Uri.parse(url),
        body: {'lid': lid, 'query': query,'cid':widget.Cid},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Query sent successfully!')),
        );
        _queryController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send query.')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sending query.')),
      );
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Query'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your query below:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _queryController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Your Query',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitQuery,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : const Text(
                'Send Query',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: messageData.length,
                itemBuilder: (BuildContext context, int index) {
                  final cname = messageData[index]['cname'];
                  final query = messageData[index]['query'];
                  final reply = messageData[index]['reply'];
                  final date = messageData[index]['date'];
                  return GestureDetector(
                    onTap: () {
                      // _showDetailsPopup(index);
                    },
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
                            Text(
                              'Company name: $cname',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Query: $query',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Reply: $reply',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Date: $date',
                              style: TextStyle(fontSize: 16),
                            ),
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
