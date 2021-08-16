import 'package:flutter/material.dart';

class GreenPage extends StatefulWidget {
  const GreenPage({Key? key}) : super(key: key);

  @override
  _GreenPageState createState() => _GreenPageState();
}

class _GreenPageState extends State<GreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(child: Text("this is the green page")),
    );
  }
}
