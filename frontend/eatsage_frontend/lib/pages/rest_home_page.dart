import 'package:eatsage_frontend/globals.dart';
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
  final String baseUrl = 'eatsage-backend.onrender.com'; // Adjust base URL

  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _fetchCurrentOrders(); // Fetch initial orders
    _startPolling(); // Start polling for updates
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
              // Implement logout functionality here
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
          : _orderData == null
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
                      Text('Customer Agent: ${_orderData!['customer_agent']}'),
                      Text('Total Cost: \$${_orderData!['totalCost']}'),
                      SizedBox(height: 16),
                      Text('Order Items:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...(_orderData!['order'] as List<dynamic>).map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Item: ${item['itemname']}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('Description: ${item['description']}'),
                              Text('Cost: \$${item['itemcost']}'),
                              SizedBox(height: 8),
                            ],
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                _acceptOrder(_orderData!['orderID']),
                            style: ElevatedButton.styleFrom(
                                iconColor: Colors.green),
                            child: Text('Accept Order',
                                style: TextStyle(color: Colors.green)),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                _declineOrder(_orderData!['orderID']),
                            style:
                                ElevatedButton.styleFrom(iconColor: Colors.red),
                            child: Text(
                              'Decline Order',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
