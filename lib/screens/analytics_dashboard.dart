import 'package:flutter/material.dart';
class Dashboard extends StatelessWidget {
  static const routeName = '/dashboard';
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics dashboard'),
      ),
      body: Text("hello")/* ListView(
        children: [
          SfSparkBarChart(
            data: <double>[1, 5, -6, 3, 8, 2.5, 10, 4, 3, 7],

          ),
          
        ],
      )*/
    );
  }
}