import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/main.dart";
import "package:heartless/services/splash/splash_services.dart";
import "package:heartless/shared/provider/auth_notifier.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    SplashServices().hasLoggedIn(authNotifier).then((value) {
      if (value) {
        Navigator.pushNamed(context, '/patientHome');
      } else {
        Navigator.pushNamed(context, '/loginPatient');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false, //to prevent pixel overflow

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
