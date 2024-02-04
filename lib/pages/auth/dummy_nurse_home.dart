import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/nurse_controller.dart';
import 'package:heartless/main.dart';
import 'package:heartless/pages/auth/scan_qr_page.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DummyNurseHome extends StatefulWidget {
  const DummyNurseHome({super.key});

  @override
  State<DummyNurseHome> createState() => _DummyHomeState();
}

class _DummyHomeState extends State<DummyNurseHome> {
  void logout() async {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    await NurseController().logout(authNotifier);
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
        title: const Text('Dummy Nurse Home'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome ${authNotifier.nurse!.name}',
                style: const TextStyle(fontSize: 20),
              ),
              Image.network(
                authNotifier.nurse!.imageUrl,
                height: 200,
              ),
              Text(authNotifier.nurse!.name),
              Text(authNotifier.nurse!.email),
              Text(authNotifier.nurse!.uid),
              QrImageView(
                  data: authNotifier.nurse!.uid,
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
            ],
          ),
        ),
      ),
    );
  }
}
