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
  Map<String, dynamic>? _valetPaymentData;

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
      setState(() {
        getValetFlag = 1;
        valetcallFlag = 0;
        valetMsgFlag = 1;
      });
      if (restpayflag == 1) {
        var valetPayUrl = Uri.http(baseUrl, '/statusPayment');
        try {
          final valetDataresponse = await http.get(valetPayUrl);

          if (valetDataresponse.statusCode == 200) {
            setState(() {
              _valetPaymentData = jsonDecode(valetDataresponse.body);
            });
          } else {
            print(
                'Failed to fetch valet information. Status code: ${valetDataresponse.statusCode}');
            print('Response body: ${valetDataresponse.body}');
          }
        } catch (e) {
          print('Error: $e');
        }
      }
    } else {
      print("Failed to accept the order. Status code: ${response.statusCode}");
      // Optionally show a message to the user here
    }
  }

  void valetDecline() async {
    setState(() {
      valetcallFlag = 0;
    });
    print("Valet Declined the order");
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
        setState(() {
          isLoading = false;
        });
        // Handle the error here, e.g., show a SnackBar or AlertDialog
        print(
            "Failed to fetch current call. Status code: ${response.statusCode}");
      }
    }
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
          title: const Text(
            "Valet Home",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: logout,
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
        drawer: MyDrawer(), // Using the MyDrawer widget here
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    callDetails == null
                        ? const Center(child: Text("No current call available"))
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Message: ${callDetails!['message']}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Order ID: ${callDetails!['orderID']}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "User Location: ${callDetails!['userloc'].join(', ')}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Restaurant Location: ${callDetails!['restaurantloc'].join(', ')}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Total Cost: \$${callDetails!['totalCost']}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: valetAccept,
                                      style: ElevatedButton.styleFrom(
                                        iconColor: Colors
                                            .green, // Button background color
                                      ),
                                      child: const Text(
                                        "Accept",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: valetDecline,
                                      style: ElevatedButton.styleFrom(
                                        iconColor: Colors
                                            .red, // Button background color
                                      ),
                                      child: const Text(
                                        "Decline",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    _valetPaymentData == null
                        ? Container() // Or some placeholder if no payment info
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                const Text(
                                  'Valet Payment Information',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Message: ${_valetPaymentData!['message']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Order ID: ${_valetPaymentData!['orderID']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Profit: \$${_valetPaymentData!['profit']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
