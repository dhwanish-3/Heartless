import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/patient_management/person_info.dart';

//! to be fetched from backend
const supervisorList = [
  {
    "imageUrl":
        'https://media.licdn.com/dms/image/D5603AQEbspLobZAZcw/profile-displayphoto-shrink_800_800/0/1687762033709?e=1714003200&v=beta&t=CaFKqrEJGIgBpEjdiDncwpVXIBtWkkar2pmgzjB_Wzs',
    "name": 'Dr. John Doe'
  },
  {
    "imageUrl":
        'https://media.licdn.com/dms/image/D5603AQEbspLobZAZcw/profile-displayphoto-shrink_800_800/0/1687762033709?e=1714003200&v=beta&t=CaFKqrEJGIgBpEjdiDncwpVXIBtWkkar2pmgzjB_Wzs',
    "name": 'Rn. Shelly Anissa'
  },
  {
    "imageUrl":
        'https://media.licdn.com/dms/image/D5603AQEbspLobZAZcw/profile-displayphoto-shrink_800_800/0/1687762033709?e=1714003200&v=beta&t=CaFKqrEJGIgBpEjdiDncwpVXIBtWkkar2pmgzjB_Wzs',
    "name": 'Dr. Kunal Nair'
  }
];

class PatientProfilePage extends StatelessWidget {
  const PatientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return const Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PersonalInfoWidget(
                name: 'Shelly Anissa',
                imageUrl:
                    'https://media.licdn.com/dms/image/D5603AQEbspLobZAZcw/profile-displayphoto-shrink_800_800/0/1687762033709?e=1714003200&v=beta&t=CaFKqrEJGIgBpEjdiDncwpVXIBtWkkar2pmgzjB_Wzs',
              ),
              SizedBox(
                height: 20,
              ),
              ControlPanel(),
              SizedBox(
                height: 20,
              ),
              SupervisorListContainer(),
            ]),
      ),
    ));
  }
}

class SupervisorListContainer extends StatelessWidget {
  const SupervisorListContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Constants.cardColor
            : Constants.darkCardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('  Attended to By',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(
            height: 4,
          ),
          Column(
            children: supervisorList.map((supervisor) {
              return Column(
                children: [
                  SupervisorTile(
                    imageUrl: supervisor['imageUrl'] as String,
                    name: supervisor['name'] as String,
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class SupervisorTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  const SupervisorTile({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                imageUrl,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ));
  }
}

class ControlPanel extends StatelessWidget {
  const ControlPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: height * 0.3,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Constants.cardColor
              : Constants.darkCardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('  Control Panel',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(
              height: 4,
            ),
            const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowImages(
                    imageUrl1: 'assets/Icons/schedule.png',
                    imageUrl2: 'assets/Icons/charts.png',
                    text1: 'Schedule',
                    text2: 'Analytics',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RowImages(
                    imageUrl1: 'assets/Icons/chat.png',
                    imageUrl2: 'assets/Icons/diary.png',
                    text1: 'Chat',
                    text2: 'Health Log',
                  ),
                  SizedBox(height: 10),
                ])
          ],
        ));
  }
}

class RowImages extends StatelessWidget {
  final String imageUrl1;
  final String imageUrl2;
  final String text1;
  final String text2;
  const RowImages({
    super.key,
    required this.imageUrl1,
    required this.imageUrl2,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        PanelCard(
          imageUrl: imageUrl1,
          text: text1,
        ),
        PanelCard(
          imageUrl: imageUrl2,
          text: text2,
        ),
      ],
    );
  }
}

class PanelCard extends StatelessWidget {
  final String imageUrl;
  final String text;
  const PanelCard({
    super.key,
    required this.imageUrl,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 140,
        width: 150,
        decoration: BoxDecoration(
          color: Constants.lightPrimaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey
                  : Colors.black,
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 60,
                child: Column(
                  children: [
                    Image.asset(
                      imageUrl,
                      height: 35,
                    ),
                    Text(text,
                        style: const TextStyle(
                          color: Colors.black,
                        )
                        // style: Theme.of(context).textTheme.bodySmall,
                        )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
