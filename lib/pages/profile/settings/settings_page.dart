import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/auth_controller.dart';
import 'package:heartless/pages/profile/settings/static_home_page.dart';
import 'package:heartless/pages/profile/settings/static_patient_management.dart';
import 'package:heartless/services/enums/color_theme.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/shared/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Settings'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
              ),
              child: Text(
                'Appearance',
                textAlign: TextAlign.start,
                // style: Theme.of(context).textTheme.headlineMedium
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).shadowColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            DarkModeToggleWidget(),
            const SizedBox(height: 20),
            ColorsWidget(),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    // padding: const EdgeInsets.all(10),
                    child: FittedBox(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: StaticHomePage(
                          user: authNotifier.appUser!,
                        ),
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(child: const SizedBox()),
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    // padding: const EdgeInsets.all(10),
                    child: FittedBox(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: StaticPatientManagement(
                          user: authNotifier.appUser!,
                        ),
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(child: const SizedBox()),
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    // padding: const EdgeInsets.all(10),
                    child: FittedBox(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: StaticHomePage(
                          user: authNotifier.appUser!,
                        ),
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ));
  }
}

class DarkModeToggleWidget extends StatelessWidget {
  const DarkModeToggleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        // color:Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).highlightColor,
            offset: const Offset(0, 0.5),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.only(
        left: 20,
        top: 20,
        bottom: 20,
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              'Dark Mode',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).shadowColor,
              ),
            ),
          ),
          Expanded(
            child: const SizedBox(),
          ),
          ThemeToggleButton(),
        ],
      ),
    );
  }
}

class ColorsWidget extends StatelessWidget {
  const ColorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeProvider =
        Provider.of<ThemeNotifier>(context, listen: false);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        // color:Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).highlightColor,
            offset: const Offset(0, 0.5),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Colors',
              textAlign: TextAlign.start,
              // style: Theme.of(context).textTheme.headlineMedium
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).shadowColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var color in ColorTheme.values)
                InkWell(
                  onTap: () {
                    log('Color: $color');
                    themeProvider.setColorTheme(color);
                    authNotifier.appUser!.theme = color;
                    AuthController().updateProfile(authNotifier.appUser!);
                  },
                  child: SingleColorWidget(
                    primaryColor: color.primaryColor,
                    secondaryColor: color.lightPrimaryColor,
                    name: color.name,
                    isSelected: color == themeProvider.colorTheme,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}

class SingleColorWidget extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final String name;
  final bool isSelected;

  const SingleColorWidget({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.name,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isSelected ? primaryColor.withOpacity(0.2) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
              ),
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 1,
                top: 1,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              )
            ],
          ),
          Text(name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).shadowColor,
              )),
        ],
      ),
    );
  }
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeProvider =
        Provider.of<ThemeNotifier>(context, listen: false);
    return InkWell(
      onTap: () {
        themeProvider.toggleThemeMode();
      },
      child: Container(
        height: 26,
        width: 50,
        decoration: BoxDecoration(
          color: ThemeNotifier.themeMode != ThemeMode.dark
              ? Colors.grey
              : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: ThemeNotifier.themeMode != ThemeMode.dark
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Container(
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).shadowColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
