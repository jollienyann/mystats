
import 'package:flutter/material.dart';
import 'package:sam/db/database.dart';
import 'package:sam/home_page.dart';

class Labo extends StatefulWidget {

  @override
  State<Labo> createState() => _LaboState();
}

class _LaboState extends State<Labo> {

  late Future? _mySum;

  @override
  void initState() {
    super.initState();
    _mySum = _fetchDataCategoryOne();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Mon labo')
      ),
    );
  }

  Future? _fetchDataCategoryOne() async {
    var result = await DBHelper.getSum();
    print(result);
    return result;
  }
}