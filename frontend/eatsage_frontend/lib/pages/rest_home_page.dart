import 'package:eatsage_frontend/globals.dart';
import 'package:eatsage_frontend/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RestHomePage extends StatefulWidget {
  @override
  _RestHomePageState createState() => _RestHomePageState();
}

class _RestHomePageState extends State<RestHomePage> {
  bool _isLoading = false;
  Map<String, dynamic>? _orderData;
  Map<String, dynamic>? _valetData;
  Map<String, dynamic>? _paymentData;
  final String baseUrl = 'eatsage-backend.onrender.com';
  Timer? _pollingTimer;
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchCurrentOrders(); // Fetch initial orders
    _startPolling(); // Start polling for updates
    if (getValetFlag == 1) {
      _fetchValetInfo(); // Fetch valet info if flag is set
    }
  }

  Future<void> _fetchCurrentOrders() async {
    setState(() {
      _isLoading = true;
    });

    var ordersUrl = Uri.https(baseUrl, '/currentOrders');

    try {
      final response = await http.get(ordersUrl);

      if (response.statusCode == 200) {
        setState(() {
          _orderData = jsonDecode(response.body);
        });
      } else {
        print(
            'Failed to fetch current orders. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _displayfoodpaymentinfo() async {
    setState(() {
      _isLoading = true;
    });

    var foodPaymentUrl = Uri.https(baseUrl, '/statusFoodPayment');

    try {
      final fpresponse = await http.get(foodPaymentUrl);

      if (fpresponse.statusCode == 200) {
        setState(() {
          _paymentData = jsonDecode(fpresponse.body);
        });
      } else {
        print(
            'Failed to fetch valet information. Status code: ${fpresponse.statusCode}');
        print('Response body: ${fpresponse.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        transflag = 0;
        restpayflag = 1;
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchValetInfo() async {
    setState(() {
      _isLoading = true;
    });

    var valetUrl = Uri.https(baseUrl, '/getValet');

    try {
      final response = await http.get(valetUrl);

      if (response.statusCode == 200) {
        setState(() {
          _valetData = jsonDecode(response.body);
        });
      } else {
        print(
            'Failed to fetch valet information. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        getValetFlag = 0;
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptOrder(String orderID) async {
    setState(() {
      _isLoading = true;
    });

    var acceptOrderUrl = Uri.https(
      baseUrl,
      '/acceptOrder',
      {
        'orderID': orderID,
        'req': 'true',
      },
    );

    try {
      final response = await http.post(
        acceptOrderUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        print('Order accepted');
        _fetchCurrentOrders(); // Refresh the orders after acceptance
        restflag = 1;
        var valetCallUrl = Uri.https(baseUrl, '/callValet');
        await http.post(valetCallUrl);
        valetcallFlag = 1;
        print("Valet Called Successfully");
        if (getValetFlag == 1) {
          _fetchValetInfo(); // Fetch valet info after calling valet
        }
        if (transflag == 1) {
          _displayfoodpaymentinfo();
        }
      } else {
        print('Failed to accept order. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        restflag = 0;
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _declineOrder(String orderID) async {
    setState(() {
      _isLoading = true;
    });

    var declineOrderUrl = Uri.https(
      baseUrl,
      '/acceptOrder',
      {
        'orderID': orderID,
        'req': 'false', // Send req as a query parameter
      },
    );

    try {
      final response = await http.post(
        declineOrderUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({}), // Empty body as query parameters are used
      );

      if (response.statusCode == 200) {
        print('Order declined');
        _fetchCurrentOrders(); // Refresh the orders after decline
      } else {
        print('Failed to decline order. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _fetchCurrentOrders();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel(); // Cancel polling when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 201, 67, 100),
        shadowColor: Colors.white,
        title: Text(
          "Restaurant Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _auth.singOut();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display Current Orders
                  _orderData == null
                      ? Center(child: Text('No orders available'))
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Orders',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                              Text('Message: ${_orderData!['message']}'),
                              Text('Order ID: ${_orderData!['orderID']}'),
                              Text(
                                  'Customer Agent: ${_orderData!['customer_agent']}'),
                              Text(
                                  'Valet Address: ${_orderData!['valet address']}'),
                              Text(
                                  'Payment Status: ${_orderData!['paymentStatus']}'),
                              Text(
                                  'Transaction Hash: ${_orderData!['transaction hash']}'),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _acceptOrder(_orderData!['orderID']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    child: Text('Accept'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _declineOrder(_orderData!['orderID']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: Text('Decline'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                  // Display Valet Information
                  _valetData == null
                      ? Container() // Or some placeholder if no valet info
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Valet Information',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                              Text('Message: ${_valetData!['valet message']}'),
                              Text(
                                  'Valet Address: ${_valetData!['valet address']}'),
                              Text(
                                  'Valet Location: ${_valetData!['valet location'].join(', ')}'),
                            ],
                          ),
                        ),
                  // Display Food Payment Information
                  _paymentData == null
                      ? Container() // Or some placeholder if no payment info
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Food Payment Information',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                              Text('Message: ${_paymentData!['message']}'),
                              Text('Order ID: ${_paymentData!['orderID']}'),
                              Text(
                                  'Customer Agent: ${_paymentData!['customer_agent']}'),
                              Text(
                                  'Valet Address: ${_paymentData!['valet address']}'),
                              Text(
                                  'Payment Status: ${_paymentData!['paymentStatus']}'),
                              Text(
                                  'Transaction Hash: ${_paymentData!['transaction hash']}'),
                            ],
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
