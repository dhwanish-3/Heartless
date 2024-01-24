import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/patient_controller.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class DummyHome extends StatefulWidget {
  const DummyHome({super.key});

  @override
  State<DummyHome> createState() => _DummyHomeState();
}

class _DummyHomeState extends State<DummyHome> {
  void logout() async {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    await PatientController().logout(authNotifier);
    if (context.mounted) {
      // ! ensure that the widget is mounted before navigating
      Navigator.pushNamed(context, '/loginPatient');
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dummy Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome ${authNotifier.patient!.name}',
              style: const TextStyle(fontSize: 20),
            ),
            Image.network(authNotifier.patient!.imageUrl),
            Text(authNotifier.patient!.name),
            Text(authNotifier.patient!.email),
            Text(authNotifier.patient!.uid),
            ElevatedButton(onPressed: logout, child: const Text('Logout')),
          ],
        ),
      ),
    );
  }
}
