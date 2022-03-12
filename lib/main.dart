// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String phone = '';
  String email = '';
  List<String> phoneList = [];
  List<String> emailList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TASK'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(30),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.greenAccent,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (input) {
                    phone = input;
                  },
                ),
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(30),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (input) {
                    email = input;
                  },
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  addPhone(phone);
                  addEmail(email);
                },
                child: const Text('Submit')),
            Flexible(child: ListView(children: _getItems()))
          ],
        ),
      ),
    );
  }

  void addPhone(String phone) {
    setState(() {
      phoneList.add(phone);
    });
  }

  void addEmail(String email) {
    setState(() {
      emailList.add(email);
    });
  }

  Widget _buildWidgetsItems(String title) {
    return ListTile(title: Text(title));
  }

  List<Widget> _getItems() {
    final List<Widget> _todoWidgets = <Widget>[];
    for (String phone in phoneList) {
      _todoWidgets.add(_buildWidgetsItems(phone));
    }
    for (String email in emailList) {
      _todoWidgets.add(_buildWidgetsItems(email));
    }
    return _todoWidgets;
  }
}
