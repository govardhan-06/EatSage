import 'package:eatsage_frontend/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'package:eatsage_frontend/components/my_drawer.dart';
import 'package:eatsage_frontend/services/auth/auth_service.dart';

class ValetHomePage extends StatefulWidget {
  const ValetHomePage({super.key});

  @override
  _ValetHomePageState createState() => _ValetHomePageState();
}

class _ValetHomePageState extends State<ValetHomePage> {
  Map<String, dynamic>? callDetails;
  bool isLoading = false;
  final String baseUrl = "eatsage-backend.onrender.com";

  void valetAccept() async {
    var callConfirmUrl = Uri.https(baseUrl, '/confirmCall', {'req': 'true'});
    final response = await http.post(
      callConfirmUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      print("Valet Accepted the order");
      getValetFlag = 1;
      print("Valet found");
      valetcallFlag = 0;
      valetMsgFlag = 1;
    } else {}
  }

  void valetDecline() async {
    valetcallFlag = 1;
  }

  Future<void> fetchCurrentCall() async {
    if (valetcallFlag == 1) {
      setState(() {
        isLoading = true;
      });
      var currentCallUrl = Uri.https(baseUrl, '/currentCall');
      final response = await http.get(currentCallUrl);

      if (response.statusCode == 200) {
        setState(() {
          callDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        // Handle the error here
        setState(() {
          isLoading = false;
        });
        // You can show a SnackBar or AlertDialog here
      }
    }
    valetcallFlag = 0;
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentCall();
  }

  void logout() {
    final _auth = AuthService();
    _auth.singOut(); // Corrected the typo here
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 201, 67, 100),
          shadowColor: Colors.white,
          title: Text(
            "Valet Home",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: logout,
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
        drawer: MyDrawer(), // Using the MyDrawer widget here
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : callDetails == null
                ? Center(child: Text("No current call available"))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Message: ${callDetails!['message']}",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Order ID: ${callDetails!['orderID']}",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "User Location: ${callDetails!['userloc'].join(', ')}",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Restaurant Location: ${callDetails!['restaurantloc'].join(', ')}",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Total Cost: \$${callDetails!['totalCost']}",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: valetAccept,
                              style: ElevatedButton.styleFrom(
                                iconColor: Colors.green,
                              ),
                              child: Text(
                                "Accept",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: valetDecline,
                              style: ElevatedButton.styleFrom(
                                iconColor: Colors.red,
                              ),
                              child: Text(
                                "Decline",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
