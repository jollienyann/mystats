import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Graphs extends StatefulWidget {

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
    );
  }
}