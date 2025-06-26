import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class admin_view_feedback extends StatefulWidget {


  const admin_view_feedback({super.key});
  @override
  _admin_view_feedbackPageState createState() => _admin_view_feedbackPageState();
}

class _admin_view_feedbackPageState extends State<admin_view_feedback> {
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
      String categoryUrl = ip! + "/api/admin_view_feedback";

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users Feedback'),
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
                  final name = messageData[index]['fname']+' '+messageData[index]['lname'];
                  final feedback = messageData[index]['feedback'];
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
                              'Name: $name',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Feedback: $feedback',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
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


