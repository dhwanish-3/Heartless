import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heartless/shared/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        // useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primaryColor: Constants().darkPrimaryColor,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SvgPicture.asset(
          'assets/illustrations/forgot_pass.svg',
          height: 64,
        ),
      ),
    );
  }
}
