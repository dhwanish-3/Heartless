import 'package:flutter/material.dart';
import "package:flutter_svg/svg.dart";
import 'package:heartless/widgets/user_type.dart';

class ChooseUserPage extends StatelessWidget {
  const ChooseUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        // fit: StackFit.loose,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              'assets/illustrations/LftBtmDsgnElmt.svg',
              height: 220,
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Text('Specify your role',
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              const Expanded(flex: 1, child: UserType()),
            ],
          ),
        ],
      ),
    );
  }
}
