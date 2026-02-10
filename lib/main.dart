import 'package:flutter/material.dart';
import 'package:momensalman/login.dart';

import 'package:momensalman/ToDo.dart';
import 'package:momensalman/insta.dart';

void main() {
  runApp(const MyApp());
}


void   dispose () {

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login  (),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        elevation: 100,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),



          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],

      ),
      body: const Center(
        child: Text("Hello Flutter"),
      ),
    );
  }
}
