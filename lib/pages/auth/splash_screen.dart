import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/backend/services/notifications/notification_services.dart";
import "package:heartless/main.dart";
import "package:heartless/services/splash/splash_services.dart";
import "package:heartless/shared/provider/auth_notifier.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Connectivity connectivity = Connectivity();
  bool isAlertSet = false;
  bool inSplashScreen = true;

  @override
  void initState() {
    getConnectivity();
    super.initState();
    connectivity.checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        showFormDialog();
        isAlertSet = true;
      } else {
        moveForward();
      }
    });
  }

  void getConnectivity() async {
    connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none && !isAlertSet) {
        showFormDialog();
        isAlertSet = true;
      }
    });
  }

  void moveForward() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    Future.delayed(const Duration(seconds: 3), () {
      SplashServices().hasLoggedIn(authNotifier).then((value) {
        if (value) {
          NotificationServices.getFirebaseMessagingToken(authNotifier);
          Navigator.pushNamed(context, '/home');
          inSplashScreen = false;
        } else {
          Navigator.pushNamed(context, '/chooseUserType');
          inSplashScreen = false;
        }
      });
    });
  }

  void showFormDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("No internet connection"),
            content: const Text("Please connect to the internet to continue"),
            actions: [
              TextButton(
                onPressed: () async {
                  if (await connectivity.checkConnectivity() !=
                          ConnectivityResult.none &&
                      isAlertSet) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      isAlertSet = false;
                      if (inSplashScreen) {
                        moveForward();
                      }
                    }
                  }
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: [
        Positioned(
          left: 0,
          bottom: 0,
          child: SvgPicture.asset(
            'assets/Icons/blueHeart.svg',
            height: screenHeight * 0.2,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Icons/Logo.png',
                height: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "HeartFull",
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
