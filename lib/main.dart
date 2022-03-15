import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/item_list_provider.dart';
import 'package:task/details_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => StateProvider(),
    child: const MyApp(),
  ));
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
  late SharedPreferences shared_preferences;
  List<Details> list = [];
  List<dynamic> lst = [];

  @override
  void initState() {
    initSP();

    super.initState();
  }

  initSP() async {
    shared_preferences = await SharedPreferences.getInstance();
    if (getDetailsFromSP() != null) {
      setState(() {
        lst = getDetailsFromSP();
        print(lst[0].runtimeType);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StateProvider>(builder: (context, stateProvider, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
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
                    keyboardType: TextInputType.phone,
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
                      setState(() {
                        phone = input;
                      });
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
                    list.add(Details(email, phone));
                    submit(list);
                    if (getDetailsFromSP() != null) {
                      setState(() {
                        lst = getDetailsFromSP();
                        print(lst[0].runtimeType);
                      });
                    }
                  },
                  child: const Text('Submit')),
              Container(
                height: 300,
                child: lst == null
                    ? ListView.builder(
                        itemCount: stateProvider.items.length,
                        itemBuilder: (context, index) {
                          return DetailsItem(
                            item: stateProvider.items[index],
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: lst.length,
                        itemBuilder: (context, index) {
                          return DetailsItemsSp(
                            item: lst[index],
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      );
    });
  }

  void saveData(List<Details> list) {
    List<String> stringList =
        list.map((item) => json.encode(item.toMap())).toList();

    shared_preferences.setStringList('list', stringList);
  }

  String validateMobile(String phone) {
    if (phone.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return '';
  }

  List<dynamic> getDetailsFromSP() {
    List<String>? value = shared_preferences.getStringList('list');
    var string = jsonDecode(value.toString());

    return string;
  }

  String validateEmail(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email))
      return 'Enter Valid Email';
    else
      return '';
  }

  void submit(List<Details> list) {
    if (validateEmail(email) == '' && validateMobile(phone) == '') {
      context.read<StateProvider>().addTask(email, phone);
      saveData(list);
    } else if (validateEmail(email) != '') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(validateEmail(email)),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(validateMobile(phone)),
      ));
    }
  }
}

class DetailsItem extends StatefulWidget {
  final Details item;
  const DetailsItem({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailsItem> createState() => _DetailsItemState();
}

class _DetailsItemState extends State<DetailsItem> {
  @override
  Widget build(BuildContext context) {
    print(widget.item.email.runtimeType);
    return Container(
      width: double.infinity,
      height: 50,
      child: Column(
        children: [
          Text(widget.item.email),
          Text(widget.item.phone),
        ],
      ),
    );
  }
}

class DetailsItemsSp extends StatefulWidget {
  final Map<String, dynamic> item;
  const DetailsItemsSp({required this.item});
  @override
  State<DetailsItemsSp> createState() => _DetailsItemsSpState();
}

class _DetailsItemsSpState extends State<DetailsItemsSp> {
  @override
  Widget build(BuildContext context) {
    print(widget.item['email'].runtimeType);
    return Container(
      width: double.infinity,
      height: 50,
      child: Column(
        children: [
          Text(widget.item['email']),
          Text(widget.item['phone']),
        ],
      ),
    );
  }
}

