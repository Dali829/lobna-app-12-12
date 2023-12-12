import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ecommerce/components/default_button.dart';
import 'package:ecommerce/screens/home/home_screen.dart';
import 'package:ecommerce/size_config.dart';

import '../../../dashboard/dashboard_screen.dart';
import '../../../main.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isAdmin = true;

  @override
  void initState() {
    super.initState();
    print(sharedPref?.getString("isAdmin"));
    print(sharedPref?.getString("role"));
    print(sharedPref?.getString("isBlocked"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          opacity: 0.2,
          fit: BoxFit.fitHeight,
        ),
      ),
      child: (sharedPref?.getString("isAdmin") != "false")
          ? ((Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/Logo.png"),
                    radius: 80,
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Text(
                  "Bienvenue \n Admin  ${sharedPref?.getString("name")}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(30),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.6,
                  child: DefaultButton(
                    text: "Vers Accueil",
                    press: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DashboardScreen()));
                    },
                  ),
                ),
                Spacer(),
              ],
            )))
          : ((sharedPref?.getString("role") == "user")
              ? Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Center(
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/Logo.png"),
                        radius: 80,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.08),
                    Text(
                      "Bienvenue \n ${sharedPref?.getString("name")}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(30),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.6,
                      child: DefaultButton(
                        text: "Vers Accueil",
                        press: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                        },
                      ),
                    ),
                    Spacer(),
                  ],
                )
              : Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Center(
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/Logo.png"),
                        radius: 80,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.08),
                    Text(
                      "Bienvenue \n Agent ${sharedPref?.getString("name")}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(30),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.6,
                      child: DefaultButton(
                        text: "Vers Accueil",
                        press: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                        },
                      ),
                    ),
                    Spacer(),
                  ],
                )),
    );
  }
}
