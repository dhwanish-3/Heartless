import "dart:developer";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/backend/services/notifications/notification_services.dart";
import "package:heartless/services/splash/splash_services.dart";
import "package:heartless/services/utils/search_service.dart";
import "package:heartless/shared/provider/auth_notifier.dart";
import "package:heartless/shared/provider/theme_provider.dart";
import "package:provider/provider.dart";

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
    ThemeNotifier themeNotifier =
        Provider.of<ThemeNotifier>(context, listen: false);
    Future.delayed(const Duration(seconds: 0), () {
      SplashServices().getUserFromFirebase(authNotifier).then((value) {
        if (value) {
          NotificationService.getFirebaseMessagingToken(authNotifier);
          SearchService.initGlobalSearchOptions(authNotifier.appUser!);
          // setting color theme & brightness
          themeNotifier.setColorTheme(authNotifier.appUser!.theme);
          log("dark mode: " + authNotifier.appUser!.brightness.toString());
          themeNotifier.setThemeMode(authNotifier.appUser!.brightness);
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
