import 'package:eatsage_frontend/globals.dart';
import 'package:eatsage_frontend/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final StreamController<List<Map<String, dynamic>>> _messagesController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  final List<Map<String, dynamic>> _messages = [];
  final String baseUrl = 'eatsage-backend.onrender.com';
  bool _isLoading = false; // To track loading state
  String _lastInputText = ''; // To store the last user input
  int restflag = 1; // Assume restflag is initialized to 1 for demonstration

  @override
  void initState() {
    super.initState();
  }

  Future<void> initAgents() async {
    var customerUrl = Uri.https(baseUrl, '/customer');
    await http.post(customerUrl);
    print("Customer Post successful");
    var restaurantUrl = Uri.https(baseUrl, '/restaurant');
    await http.post(restaurantUrl);
    print("Restaurant Post successful");
    var valetUrl = Uri.https(baseUrl, '/valet');
    await http.post(valetUrl);
    print("Valet Post successful");
  }

  void logout() {
    final _auth = AuthService();
    _auth.singOut();
  }

  Future<void> send() async {
    final text = _textEditingController.text;

    if (text.isNotEmpty) {
      _messages.add({'text': text, 'isUser': true}); // Add user message
      _textEditingController.clear();
      _messagesController.add(List.from(_messages)); // Update stream

      setState(() {
        _isLoading = true; // Show loading indicator
      });

      await initAgents();

      _lastInputText = text; // Store the last user input

      var promptUrl = Uri.https(baseUrl, '/prompt', {'prompt': text});
      try {
        final response = await http.post(
          promptUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        setState(() {
          _isLoading = false; // Hide loading indicator
        });

        if (response.statusCode == 200) {
          // Successfully posted, get the response data
          final responseData = jsonDecode(response.body);
          // Assuming responseData['dishes'] contains the dishes array
          final apiResponse = responseData ?? 'No response message';

          // Format the response data
          String formattedResponse =
              'Restaurant: ${apiResponse['restaurant']}\n';
          apiResponse['dishes'].forEach((dish) {
            formattedResponse += '\nDish: ${dish['itemname']}\n'
                'Description: ${dish['description']}\n'
                'Cost: \$${dish['itemcost']}\n';
          });

          // Add formatted API response to messages
          _messages.add({
            'text': formattedResponse,
            'isUser': false,
            'showButtons': true
          });
          _messagesController.add(List.from(_messages)); // Update stream
        } else if (response.statusCode == 422) {
          print('Unprocessable Entity: ${response.body}');
        } else {
          print(
              'Failed to post prompt data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        print('Error: $e');
      }
    }
  }

  Future<void> rejection() async {
    if (_lastInputText.isNotEmpty) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      var promptUrl = Uri.https(baseUrl, '/prompt', {'prompt': _lastInputText});
      try {
        final response = await http.post(
          promptUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        setState(() {
          _isLoading = false; // Hide loading indicator
        });

        if (response.statusCode == 200) {
          // Successfully posted, get the response data
          final responseData = jsonDecode(response.body);
          // Assuming responseData['dishes'] contains the dishes array
          final apiResponse = responseData ?? 'No response message';

          // Format the response data
          String formattedResponse =
              'Restaurant: ${apiResponse['restaurant']}\n';
          apiResponse['dishes'].forEach((dish) {
            formattedResponse += '\nDish: ${dish['itemname']}\n'
                'Description: ${dish['description']}\n'
                'Cost: \$${dish['itemcost']}\n';
          });

          // Add formatted API response to messages
          _messages.add({
            'text': formattedResponse,
            'isUser': false,
            'showButtons': true
          });
          _messagesController.add(List.from(_messages)); // Update stream
        } else if (response.statusCode == 422) {
          print('Unprocessable Entity: ${response.body}');
        } else {
          print(
              'Failed to post prompt data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        print('Error: $e');
      }
    }
  }

  Future<void> accepted() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    var confirmOrderUrl = Uri.https(baseUrl, '/confirmOrder', {
      'req': 'true',
    });

    try {
      final response = await http.post(
        confirmOrderUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            {}), // Empty body since the request only needs the query parameter
      );

      if (response.statusCode == 200) {
        // Successfully confirmed the order
        print("Order confirmed");

        if (restflag == 1) {
          // Fetch the confirmation message from the restaurant agent
          var resConfirmUrl = Uri.https(baseUrl, '/resConfirm');

          try {
            final resConfirmResponse = await http.get(resConfirmUrl);

            if (resConfirmResponse.statusCode == 200) {
              final responseData = jsonDecode(resConfirmResponse.body);
              final formattedResponse = 'Message: ${responseData['message']}\n'
                  'Order ID: ${responseData['orderID']}\n'
                  'Status: ${responseData['status'] ? 'Accepted' : 'Rejected'}\n'
                  'Total Cost: \$${responseData['totalCost']}';

              _messages.add({
                'text': formattedResponse,
                'isUser': false,
              });
              _messagesController.add(List.from(_messages)); // Update stream
              if (valetMsgFlag == 1) {
                var valetmsgUrl = Uri.https(baseUrl, '/valetMessage');
                final valetmsgResponse = await http.get(valetmsgUrl);

                if (valetmsgResponse.statusCode == 200) {
                  final valetMsgData = jsonDecode(valetmsgResponse.body);
                  final valetMsgFormatted =
                      'Message: ${responseData['message']}\n'
                      'Valet Address: ${responseData['valet address']}\n'
                      'Valet Message: ${responseData['valet message']}';
                  _messages.add({
                    'text': valetMsgFormatted,
                    'isUser': false,
                  });
                }
              }
            } else {
              print(
                  'Failed to fetch confirmation message. Status code: ${resConfirmResponse.statusCode}');
              print('Response body: ${resConfirmResponse.body}');
            }
          } catch (e) {
            print('Error: $e');
          }
        }
      } else {
        print('Failed to confirm order. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
        restflag = 0;
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _messagesController.close();
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
          "Home",
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
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messagesController.stream,
              builder: (context, snapshot) {
                if (_isLoading) {
                  return Center(
                    child: Text(
                      "Working on it...",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        color: const Color.fromARGB(255, 201, 67, 100),
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text(
                      "Type your eating preferences!",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        color: const Color.fromARGB(255, 201, 67, 100),
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data![index];
                      final isUserMessage = message['isUser'] ?? false;
                      final showButtons = message['showButtons'] ?? false;

                      return Column(
                        crossAxisAlignment: isUserMessage
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (index > 0)
                            SizedBox(
                              height: 10,
                            ), // SizedBox between messages
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? const Color.fromARGB(255, 201, 67, 100)
                                  : const Color.fromARGB(255, 23, 23, 23),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['text'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins'),
                                ),
                                if (showButtons)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                        onPressed: accepted,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                        onPressed: rejection,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Tell the sage your preferences!'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 201, 67, 100)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 201, 67, 100)),
                      ),
                      labelText: 'Enter your preferences',
                      labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: const Color.fromARGB(255, 201, 67, 100)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  color: const Color.fromARGB(255, 201, 67, 100),
                  onPressed: send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
