import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/patient_controller.dart';
import 'package:heartless/main.dart';
import 'package:heartless/pages/auth/scan_qr_page.dart';
import 'package:heartless/pages/chat/contacts_page.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      Navigator.pushNamed(context, '/login');
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome ${authNotifier.patient!.name}',
                style: const TextStyle(fontSize: 20),
              ),
              Image.network(
                authNotifier.patient!.imageUrl,
                height: 200,
              ),
              Text(authNotifier.patient!.name),
              Text(authNotifier.patient!.email),
              Text(authNotifier.patient!.uid),
              QrImageView(
                  data: authNotifier.patient!.uid,
                  size: 200,
                  backgroundColor: Colors.white,
                  errorStateBuilder: (cxt, err) {
                    return const Center(
                      child: Text("Uh oh! Something went wrong..."),
                    );
                  }),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ScanQR()));
                  },
                  child: const Text('Scan QR')),
              ElevatedButton(onPressed: logout, child: const Text('Logout')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ContactsPage()));
                  },
                  child: const Text('Contacts page')),
            ],
          ),
        ),
      ),
    );
  }
}
