import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
              SvgPicture.asset(
                'assets/Icons/heart.svg',
                height: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Heartless",
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




// 4
// 5
// 6
// 8
// 14
// 16
// 17
